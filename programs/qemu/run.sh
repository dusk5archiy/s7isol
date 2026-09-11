


VarsFile=""
TpmDir=""
cleanup() {
  [[ -n $TpmDir && -d $TpmDir ]] && rm -rf "$TpmDir"
  [[ -n $VarsFile && -f $VarsFile ]] && rm -f "$VarsFile"
}
trap cleanup EXIT

# ------------------------------------------------------------------------------
RawDrives=()
Memory=4G
Cpu=host
CpuCores=4

# ------------------------------------------------------------------------------
# Check for any CD mounts
HasCdrom=false

UseMouse=true
UseAudio=true

# OVMF
UseOvmf=false

# Window & Virtio
UseWindows=false
UseVirtio=false
VirtioIso=/var/lib/libvirt/images/virtio-win.iso
UseAhci=false
UseScsi=false

# Dummy VirtIO disk tracking
UseDummy=false
DummyDisk=""

QemuArgs=(
  -accel kvm
  -display "gtk,zoom-to-fit=on"
)

# ------------------------------------------------------------------------------

while [[ $# -gt 0 ]]; do
  Arg=$1

  case $Arg in
  --memory) shift && Memory=$1 ;;
  --cores) shift && CpuCores=$1 ;;
  --migrate) Cpu=host,migratable=on ;;
  --no-mouse) UseMouse=false ;;
  --no-audio) shift && UseAudio=false ;;
  --windows) UseWindows=true && UseOvmf=true && UseVirtio=true ;;
  --virtio) UseVirtio=true ;;
  --ovmf) UseOvmf=true ;;
  --ahci) UseAhci=true ;;
  --dummy)
    shift
    UseDummy=true
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
  *.iso)
    if [[ ! -f $Arg ]]; then
      echo "[-- error --] specified file does not exist: $Arg" >&2
      exit 1
    fi
    QemuArgs+=(-cdrom "$Arg")
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
EnableTmp() {
  TpmDir="/tmp/mytpm_$$"
  mkdir -p "$TpmDir"
  swtpm socket --tpmstate dir="$TpmDir" --ctrl type=unixio,path="$TpmDir/swtpm-sock" --tpm2 --daemon
}

# Hypervisor enlightenments, q35 machine
EnableQ35() {
  Cpu="host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time"
  QemuArgs+=(
    -machine "q35,smm=on"
    -global "driver=cfi.pflash01,property=secure,value=on"
    -global "ICH9-LPC.disable_s3=1"
    -chardev "socket,id=chrtpm,path=$TpmDir/swtpm-sock"
    -tpmdev "emulator,id=tpm0,chardev=chrtpm"
    -device "tpm-tis,tpmdev=tpm0"
  )
}

# Core Functions ===============================================================
# Virtio -----------------------------------------------------------------------
EnableVirtioNetwork() {
  QemuArgs+=(
    -device virtio-serial-pci
  )
  QemuArgs+=(
    -netdev "user,id=net0"
    -device "virtio-net-pci,netdev=net0"
  )
}

AddVirtioIso() {
  sudo chmod 644 /var/lib/libvirt/images/virtio-win.iso
  sudo chmod 755 /var/lib/libvirt/images
  QemuArgs+=(-drive "file=$VirtioIso,media=cdrom,readonly=on")
}

# OVMF -------------------------------------------------------------------------
# OVMF stands for Open Virtual Machine Firmware
# UEFI BIOS for virtual machines
EnableOvmf() {
  VarsFile="/tmp/ovmf_vars_$$.fd"

  cp /usr/share/edk2/x64/OVMF_VARS.4m.fd "$VarsFile"
  QemuArgs+=(
    -drive "if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd"
    -drive "if=pflash,format=raw,file=$VarsFile"
  )
}
# Others -----------------------------------------------------------------------
EnableMouse() {
  QemuArgs+=(
    -usb
    -device usb-tablet
    -device usb-kbd
    -device usb-mouse
  )
}

EnableAudio() {
  QemuArgs+=(
    -device ich9-intel-hda
    -audiodev "pipewire,id=snd0"
    -device "hda-duplex,audiodev=snd0"
  )
}

EnableAhci() {
  QemuArgs+=(-device "ahci,id=ahci")
}

EnableScsi() {
  QemuArgs+=(-device "virtio-scsi-pci,id=scsi")
}

# Orchestrators ================================================================
EnableWindows() {
  EnableTmp
  EnableQ35
}

# Gates ========================================================================
if [[ $UseWindows == true ]]; then EnableWindows; fi
if [[ $UseVirtio == true ]]; then EnableVirtioNetwork && AddVirtioIso; fi
if [[ $UseOvmf == true ]]; then EnableOvmf; fi
if [[ $UseMouse == true ]]; then EnableMouse; fi
if [[ $UseAudio == true ]]; then EnableAudio; fi
if [[ $UseAhci == true ]]; then EnableAhci; fi
if [[ $UseScsi == true ]]; then EnableScsi; fi

# Disk Mounts ==================================================================
# Process drives AFTER controller initialization so bus=ahci0.x exists in QemuArgs sequence

DriveIdx=0
AhciIdx=0
ScsiIdx=0

for DriveFile in "${RawDrives[@]}"; do
  # Set raw format for block devices
  if [[ -b "$DriveFile" || "$DriveFile" == /dev/* ]]; then
    FileExtension="raw"
  else
    FileExtension="${DriveFile##*.}"
    [[ "$FileExtension" == "img" ]] && FileExtension="raw"
  fi

  if [[ "$UseWindows" == true ]]; then
    DriveId="drive-win${DriveIdx}"
    DeviceArg=()

    if [[ "$DriveFile" =~ ^/dev/nvme[0-9]+n[0-9]+$ ]]; then
      DeviceArg+=(-device "nvme,drive=$DriveId,serial=nvme${DriveIdx}")
    else
      if [[ $UseAhci == true ]]; then
        QemuArgs+=(-device "ide-hd,drive=$DriveId,bus=ahci.$AhciIdx") && ((++AhciIdx))
      elif [[ $UseVirtio == true ]]; then
        DeviceArg+=(-device "virtio-blk-pci,drive=$DriveId")
      elif [[ $UseScsi == true ]]; then
        QemuArgs+=(-device "scsi-hd,drive=$DriveId,bus=scsi.$ScsiIdx") && ((++ScsiIdx))
      else
        QemuArgs+=(-device "ide-hd,drive=$DriveId")
      fi
    fi
    QemuArgs+=(
      -drive "file=$DriveFile,format=$FileExtension,if=none,id=$DriveId"
      "${DeviceArg[@]}"
    )
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
    -drive "file=$DummyDisk,format=$DummyExtension,if=none,id=drive-dummy"
    -device "virtio-blk-pci,drive=drive-dummy"
  )
fi

# ==============================================================================
QemuArgs+=(
  -cpu "$Cpu"
  -m "$Memory"
  -smp "$CpuCores,sockets=1,cores=$CpuCores,threads=1"
)

if [[ "$HasCdrom" == true ]]; then
  QemuArgs+=(-boot "order=dc")
else
  QemuArgs+=(-boot "order=c")
fi

# ------------------------------------------------------------------------------

echo "QemuArgs: ${QemuArgs[*]}"

sudo XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" qemu-system-x86_64 "${QemuArgs[@]}"
