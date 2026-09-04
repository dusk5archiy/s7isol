#!/bin/bash
set -euo pipefail

# Cleanup temporary files on exit
TpmDir=""
VarsFile=""
cleanup() {
  [[ -n $TpmDir && -d $TpmDir ]] && rm -rf $TpmDir
  [[ -n $VarsFile && -f $VarsFile ]] && rm -f $VarsFile
}
trap cleanup EXIT

if [[ $# -eq 0 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  cat <<EOF
Usage: $S7ISOL_TARGET <file1> [file2 ...] [OPTIONS]

Run a QEMU x86_64 virtual machine with auto-detected media files.

Arguments:
  <file...>         List of image files (.iso, .qcow2, .img, .raw, etc.)

Options:
  -h, --help        Show this help message and exit.
  --windows         Enable Windows 11 optimizations (VirtIO, TPM 2.0, UEFI OVMF, q35).
  --memory <size>   Set RAM size (default: 8G).
  --cores <num>     Set CPU cores (default: 4).
  --usb VENDOR:PROD Passthrough a USB device by Vendor:Product ID.
EOF
  exit 0
fi

RawDrives=()
QemuArgs=(
  -accel kvm
  -vga none
  -device virtio-vga
  -display "gtk,zoom-to-fit=on"
)

Memory=4G
Cpu=host
CpuCores=4

UseMouse=true
UseAudio=true
HasCdrom=false
UseWindows=false
UseOvmf=false
VirtioIso=/var/lib/libvirt/images/virtio-win.iso
UseVirtio=false

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

if [[ $UseWindows == true ]]; then
  # 1. TPM 2.0 Setup
  TpmDir="/tmp/mytpm_$$"
  mkdir -p "$TpmDir"
  swtpm socket --tpmstate dir="$TpmDir" \
    --ctrl type=unixio,path="$TpmDir/swtpm-sock" \
    --tpm2 \
    --daemon

  # Hypervisor enlightenments, q35 machine
  Cpu="host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time"
  QemuArgs+=(
    -machine q35
    -chardev "socket,id=chrtpm,path=$TpmDir/swtpm-sock"
    -tpmdev "emulator,id=tpm0,chardev=chrtpm"
    -device "tpm-tis,tpmdev=tpm0"
  )

  # 2. VirtIO Network Card
  QemuArgs+=(
    -netdev "user,id=net0"
    -device "virtio-net-pci,netdev=net0"
  )
fi

if [[ $UseVirtio == true ]]; then
  sudo chmod 644 /var/lib/libvirt/images/virtio-win.iso
  sudo chmod 755 /var/lib/libvirt/images
  QemuArgs+=(-drive "file=$VirtioIso,media=cdrom,readonly=on")
fi

# ------------------------------------------------------------------------------
# Process drives AFTER controller initialization so bus=ahci0.x exists in QemuArgs sequence
DriveIdx=0
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

    if [[ "$DriveFile" =~ ^/dev/nvme[0-9]+n[0-9]+$ ]]; then
      DeviceArg=(-device "nvme,drive=$DriveId,serial=nvme${DriveIdx}")
    else
      DeviceArg=(-device "ide-hd,drive=$DriveId")
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

# ------------------------------------------------------------------------------

if [[ $UseOvmf == true ]]; then
  VarsFile="/tmp/ovmf_vars_$$.fd"
  cp /usr/share/edk2/x64/OVMF_VARS.4m.fd "$VarsFile"
  QemuArgs+=(
    -drive "if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd"
    -drive "if=pflash,format=raw,file=$VarsFile"
  )
fi

# ------------------------------------------------------------------------------

QemuArgs+=(
  -cpu "$Cpu"
  -m "$Memory"
  -smp "$CpuCores"
)

# ------------------------------------------------------------------------------

if [[ $UseMouse == true ]]; then
  QemuArgs+=(
    -usb
    -device usb-tablet
    -device usb-kbd
    -device usb-mouse
  )
fi

# ------------------------------------------------------------------------------

if [[ $UseAudio == true ]]; then
  QemuArgs+=(
    -device ich9-intel-hda
    -audiodev "pipewire,id=snd0"
    -device "hda-duplex,audiodev=snd0"
  )
fi

# ------------------------------------------------------------------------------

if [[ "$HasCdrom" == true ]]; then
  QemuArgs+=(-boot "order=dc")
else
  QemuArgs+=(-boot "order=c")
fi

# ------------------------------------------------------------------------------

echo "QemuArgs: ${QemuArgs[*]}"

sudo XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" qemu-system-x86_64 "${QemuArgs[@]}"
