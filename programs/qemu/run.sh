VarsFile=""
TpmDir=""
cleanup() {
  [[ -n $TpmDir && -d $TpmDir ]] && rm -rf "$TpmDir"
  [[ -n $VarsFile && -f $VarsFile ]] && rm -f "$VarsFile"
}
trap cleanup EXIT

# ------------------------------------------------------------------------------
RawDrives=()
IsoFiles=()
Memory=4G
Cpu=host
CpuCores=4

# ------------------------------------------------------------------------------
# Check for any CD mounts
HasCdrom=false

UseMouse=true
UseAudio=true
UseConn=true

UseOvmf=false
UseTpm=false
UseSafeBoot=false

# Window & Virtio
UseWindows=false
UseVirtio=false
UseVirtioIso=false
VirtioIso=/var/lib/libvirt/images/virtio-win.iso
UseAhci=true

# Dummy VirtIO disk tracking
UseDummy=false
DummyDisk=""

QemuArgs=(
  -accel kvm
  -display "gtk,zoom-to-fit=on"
  # -display gtk
)

# ------------------------------------------------------------------------------

while [[ $# -gt 0 ]]; do
  Arg=$1

  case $Arg in
  --memory) shift && Memory=$1 ;;
  --cores) shift && CpuCores=$1 ;;
  --windows) UseWindows=true && UseOvmf=true && UseTpm=true && UseSafeBoot=true ;;
  --no-conn) UseConn=false ;;
  --no-mouse) UseMouse=false ;;
  --no-audio) UseAudio=false ;;
  --no-tpm) UseTpm=false ;;
  --no-safe-boot) UseSafeBoot=false ;;
  --virtio-iso) UseVirtioIso=true ;;
  --virtio) UseVirtio=true && UseAhci=false && UseVirtioIso=true ;;
  --ovmf) UseOvmf=true ;;
  --dummy)
    shift
    UseDummy=true
    UseVirtioIso=true
    DummyDisk=$1
    if [[ ! -e "$DummyDisk" ]]; then
      echo "[-- error --] specified dummy disk does not exist: $DummyDisk" >&2
      exit 1
    fi
    ;;
  --usb)
    shift
    IFS=':' read -r Vendor Product <<<"$1"
    if ! lsusb -d "$Vendor:$Product" &>/dev/null; then
      echo "[-- error --] USB device $Vendor:$Product not found on host" >&2
      exit 1
    fi
    QemuArgs+=(
      -device "usb-host,vendorid=0x$Vendor,productid=0x$Product"
    )
    ;;
  --vfio)
    shift
    Host=$1
    sudo modprobe vfio-pci
    (
      Dir=$(dirname "${BASH_SOURCE[0]}")
      bash "$Dir/../../scripts/iommu/up.sh" "$Host"
    )
    QemuArgs+=(-device "vfio-pci,host=$Host")
    ;;
  *.iso)
    if [[ ! -f $Arg ]]; then
      echo "[-- error --] specified file does not exist: $Arg" >&2
      exit 1
    fi
    IsoFiles+=("$Arg")
    HasCdrom=true
    ;;
  *)
    if [[ ! -e "$Arg" ]]; then
      echo "[-- error --] specified file does not exist: $Arg" >&2
      exit 1
    fi
    RawDrives+=("$Arg")
    ;;
  esac
  shift
done

# ------------------------------------------------------------------------------
# TPM 2.0 Setup
EnableTpm() {
  TpmDir="/tmp/mytpm_$$"
  mkdir -p "$TpmDir"
  swtpm socket --tpmstate dir="$TpmDir" --ctrl type=unixio,path="$TpmDir/swtpm-sock" --tpm2 --daemon
  QemuArgs+=(
    -chardev "socket,id=chrtpm,path=$TpmDir/swtpm-sock"
    -tpmdev "emulator,id=tpm0,chardev=chrtpm"
    -device "tpm-tis,tpmdev=tpm0"
  )
}

EnableSafeBoot() {
  QemuArgs+=(
    -global "driver=cfi.pflash01,property=secure,value=on"
  )
}

# Hypervisor enlightenments, q35 machine
EnableQ35() {
  # local MachineVendor && MachineVendor="$(cat /sys/class/dmi/id/sys_vendor 2>/dev/null)"
  # local MachineProduct && MachineProduct="$(cat /sys/class/dmi/id/product_name 2>/dev/null)"
  # local MachineVersion && MachineVersion="$(cat /sys/class/dmi/id/product_version 2>/dev/null)"

  Cpu="host,hv-passthrough,level=30,+vmx"
  QemuArgs+=(
    -machine "q35,smm=on"
    -global "ICH9-LPC.disable_s3=1"
    # -smbios "type=0,vendor=${MachineVendor}"
    # -smbios "type=1,manufacturer=${MachineVendor},product=${MachineProduct},version=${MachineVersion}"
  )
}

# Core Functions ===============================================================
# Virtio -----------------------------------------------------------------------
EnableVirtio() {
  sudo chmod 644 /var/lib/libvirt/images/virtio-win.iso
  sudo chmod 755 /var/lib/libvirt/images
  QemuArgs+=(
    -device virtio-serial-pci
    -device "virtio-scsi-pci,id=scsi"
  )

  QemuArgs+=(
    -vga none
    -device "virtio-vga,xres=1920,yres=1080"
  )
}

EnableVirtioIso() {
  QemuArgs+=(
    -drive "file=$VirtioIso,media=cdrom,readonly=on"
  )
}

# OVMF -------------------------------------------------------------------------
EnableOvmf() {
  VarsFile="/tmp/ovmf_vars_$$.fd"

  cp /usr/share/edk2/x64/OVMF_VARS.4m.fd "$VarsFile"
  QemuArgs+=(
    # -drive "if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd"
    -drive "if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd"
    -drive "if=pflash,format=raw,file=$VarsFile"
  )
}
# Others -----------------------------------------------------------------------
EnableMouse() {
  QemuArgs+=(
    -usb
    -device usb-kbd
  )
  if [[ $UseVirtio == true ]]; then
    QemuArgs+=(
      -device virtio-tablet-pci
    )
  else
    QemuArgs+=(
      # -device usb-mouse
      -device usb-tablet
    )
  fi

}

EnableAudio() {
  QemuArgs+=(
    -device ich9-intel-hda
    -audiodev "pipewire,id=snd0,out.frequency=48000,out.buffer-length=50000"
    -device "hda-output,audiodev=snd0"
    # -audiodev "pipewire,id=snd0"
    # -device "hda-duplex,audiodev=snd0"
  )
}

EnableAhci() {
  QemuArgs+=(-device "ahci,id=ahci")
}

EnableConn() {
  QemuArgs+=(
    -netdev "user,id=net0"
    -device "e1000e,netdev=net0"
  )
}

# Orchestrators ================================================================
EnableWindows() {
  EnableQ35
}

# Gates ========================================================================
if [[ $UseWindows == true ]]; then EnableWindows; fi
if [[ $UseTpm == true ]]; then EnableTpm; fi
if [[ $UseSafeBoot == true ]]; then EnableSafeBoot; fi
if [[ $UseVirtio == true ]]; then EnableVirtio; fi
if [[ $UseOvmf == true ]]; then EnableOvmf; fi
if [[ $UseMouse == true ]]; then EnableMouse; fi
if [[ $UseAudio == true ]]; then EnableAudio; fi
if [[ $UseAhci == true ]]; then EnableAhci; fi
if [[ $UseConn == true ]]; then EnableConn; fi
if [[ $UseVirtioIso == true ]]; then EnableVirtioIso; fi

# Disk Mounts ==================================================================
DriveIdx=0
AhciIdx=0
ScsiIdx=0

for DriveFile in "${RawDrives[@]}"; do
  if [[ -b "$DriveFile" || "$DriveFile" == /dev/* ]]; then
    FileExtension="raw"
  else
    FileExtension="${DriveFile##*.}"
    [[ "$FileExtension" == "img" ]] && FileExtension="raw"
  fi

  if [[ "$UseWindows" == true ]]; then
    DriveId="drive-win${DriveIdx}"
    If=none
    QemuArgs+=(
      -drive "file=$DriveFile,format=$FileExtension,if=$If,id=$DriveId,cache=none,aio=threads"
    )

    if [[ "$DriveFile" =~ ^/dev/nvme[0-9]+n[0-9]+$ ]]; then
      QemuArgs+=(-device "nvme,drive=$DriveId,serial=nvme${DriveIdx}")
    elif [[ $UseAhci == true ]]; then
      QemuArgs+=(-device "ide-hd,drive=$DriveId,bus=ahci.$AhciIdx") && ((++AhciIdx))
    elif [[ $UseVirtio == true ]]; then
      QemuArgs+=(-device "scsi-hd,drive=$DriveId,bus=scsi.0") && ((++ScsiIdx))
    else
      QemuArgs+=(-device "ide-hd,drive=$DriveId")
    fi
    ((++DriveIdx))
  else
    QemuArgs+=(-drive "file=$DriveFile,format=$FileExtension")
  fi
done

# Attach Dummy VirtIO Disk if specified
if [[ $UseDummy == true ]]; then
  DummyExtension="${DummyDisk##*.}"
  [[ "$DummyExtension" == "img" ]] && DummyExtension="raw"
  if [[ -b "$DummyDisk" || "$DummyDisk" == /dev/* ]]; then
    DummyExtension="raw"
  fi
  QemuArgs+=(
    -device "virtio-scsi-pci,id=scsi"
    -drive "file=$DummyDisk,format=$DummyExtension,if=none,id=drive-dummy"
    -device "scsi-hd,drive=drive-dummy,bus=scsi.0"
  )
fi

# ==============================================================================
# Parse and attach multiple ISO files safely without bus conflicts
IsoIdx=0
for IsoFile in "${IsoFiles[@]}"; do
  QemuArgs+=(-drive "file=$IsoFile,media=cdrom,readonly=on,if=none,id=cdrom${IsoIdx}")
  QemuArgs+=(-device "ide-cd,drive=cdrom${IsoIdx},bus=ahci.${AhciIdx}")
  ((++AhciIdx))
  ((++IsoIdx))
done

QemuArgs+=(
  -cpu "$Cpu"
  -m "$Memory"
  -smp "$CpuCores,sockets=1,cores=$CpuCores,threads=1"
  -device "pcie-root-port,id=pcie.1,chassis=1,slot=1"
)

if [[ "$HasCdrom" == true ]]; then
  QemuArgs+=(-boot "order=dc")
else
  QemuArgs+=(-boot "order=c")
fi

# ------------------------------------------------------------------------------

echo "QemuArgs: ${QemuArgs[*]}"

sudo XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" qemu-system-x86_64 "${QemuArgs[@]}"
