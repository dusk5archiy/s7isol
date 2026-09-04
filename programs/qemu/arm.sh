#!/bin/bash
set -euo pipefail

# Defaults
KernelFile=$HOME/rpi-kernel-build/output/Image
RootDev=/dev/vda2
Memory=4G
CPUs=4
UseUI=true

# Check for help flag or missing arguments
if [[ $# -eq 0 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  cat <<EOF
Usage: $S7ISOL_TARGET <DiskOrImage> [OPTIONS]

Boots an ARM64 OS (e.g., Raspberry Pi OS) inside a QEMU ARM 'virt' machine,
passing a physical block device or raw image file as a VirtIO drive.

Arguments:
  Disk            Path to block device (/dev/sdX, /dev/nvme0n1) or raw image file.

Options:
  -k, --kernel    Kernel image path (default: $KernelFile)
  -r, --root      Root partition device in guest (default: $RootDev)
  -m, --memory    RAM allocation (default: 2G)
  -c, --cpus      CPU core count (default: 4)
  -h, --help      Show this help message and exit.

Examples:
  # Boot directly from an SD card block device:
  $S7ISOL_TARGET /dev/sdb

  # Boot from a raw disk image file with 4G RAM:
  $S7ISOL_TARGET raspios.img -m 4G
EOF
  exit 0
fi

Disk="$1"
shift

# Parse optional arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -k | --kernel)
    KernelFile=$2
    shift 2
    ;;
  -r | --root)
    RootDev=$2
    shift 2
    ;;
  -m | --memory)
    Memory=$2
    shift 2
    ;;
  -c | --cpus)
    CPUs=$2
    shift 2
    ;;
  --no-ui)
    UseUI=false
    shift 1
    ;;
  *)
    echo "[-- error --] unknown option: $1" >&2
    exit 1
    ;;
  esac
done

# Validate target drive (block device or regular disk file)
if [[ ! -b $Disk && ! -f $Disk ]]; then
  echo "[-- error --] '$Disk' is neither a valid block device nor a regular image file." >&2
  exit 1
fi

# Validate kernel binary existence
if [[ ! -f $KernelFile ]]; then
  echo "[-- error --] Kernel file not found at: '$KernelFile'" >&2
  exit 1
fi

TmpDir=/tmp/pi-virt-boot
mkdir -p "$TmpDir"
cp "$KernelFile" "$TmpDir/Image"

# Build QEMU arguments array
QemuArgs=(
  -M virt
  -cpu cortex-a72
  -smp "$CPUs"
  -m "$Memory"
  -kernel "$TmpDir/Image"
  -drive "file=$Disk,if=none,id=hd0,format=raw,file.locking=off"
  -device "virtio-blk-pci,drive=hd0"
  -netdev "user,id=net0,hostfwd=tcp::2222-:22"
  -device "virtio-net-pci,netdev=net0"
  --no-reboot
)

if [[ $UseUI == true ]]; then
  # GUI mode: Routes console to GTK window tab and attaches a display card
  QemuArgs+=(
    -append "root=$RootDev rw rootfstype=ext4 rootwait console=tty0"
    # -append "systemd.mask=systemd-networkd-wait-online.service"
    -device "virtio-gpu-pci"
    -serial "vc"
    -display "gtk,zoom-to-fit=on"
    -device "qemu-xhci,id=usb"
    -device "usb-tablet,bus=usb.0"
    -device "usb-kbd,bus=usb.0"
  )
else
  # Terminal mode: Routes console cleanly to host stdout without opening a GUI window
  QemuArgs+=(
    -append "root=$RootDev rw rootfstype=ext4 rootwait console=ttyAMA0 earlycon=pl011,mmio32,0x09000000"
    -serial stdio
    -display none
  )
fi

# Run with sudo if accessing a physical block device to avoid permission errors
if [[ -b "$Disk" && $EUID -ne 0 ]]; then
  echo "[-- info --] Target is a block device. Elevating permissions via sudo..."
  exec sudo qemu-system-aarch64 "${QemuArgs[@]}"
else
  exec qemu-system-aarch64 "${QemuArgs[@]}"
fi
