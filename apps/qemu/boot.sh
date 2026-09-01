#!/bin/bash
set -euo pipefail

Disk=${1:-}
if [[ -z $Disk || ! -b $Disk ]]; then
  echo "[-- error --] '$Disk' is not a block device."
  exit 1
fi

# -----------------------------------------------------------------------------
# OLD: Extracting stock kernel/DTB/initramfs from physical SD card FAT partition
# -----------------------------------------------------------------------------
# if [[ "$Disk" =~ [0-9]$ ]]; then
#   BootPartition="${Disk}p1"
# else
#   BootPartition="${Disk}1"
# fi
#
# TmpDir=/tmp/pi-boot
# sudo mkdir -p $TmpDir
# sudo rm -rf $TmpDir/*
#
# sudo mcopy -i "$BootPartition" ::kernel8.img $TmpDir/kernel8.img
# sudo mcopy -i "$BootPartition" ::bcm2711-rpi-4-b.dtb $TmpDir/rpi4.dtb
# sudo mcopy -i "$BootPartition" ::initramfs8 $TmpDir/initramfs8

# -----------------------------------------------------------------------------
# NEW: Using custom VirtIO-enabled kernel from build output directory
# -----------------------------------------------------------------------------
TmpDir=/tmp/pi-boot
mkdir -p "$TmpDir"
rm -rf "${TmpDir:?}"/*
cp "$HOME/rpi-kernel-build/output/Image" "$TmpDir/Image"

# Optional: Keep your init override command if you want direct root access,
# or set Init="" to boot standard Raspberry Pi OS initd/systemd.
# Command="ip a"
# InitCommand="/bin/mount -t proc p /proc; /bin/mount -t sysfs s /sys; export PATH=/bin; $Command; exec sleep infinity"
# Init="init=/bin/bash -- -c \"$InitCommand\""

# -----------------------------------------------------------------------------
# OLD QEMU -M raspi4b Execution
# -----------------------------------------------------------------------------
# sudo qemu-system-aarch64 -M raspi4b -cpu cortex-a72 -m 2G -smp 4 \
#   -kernel $TmpDir/kernel8.img \
#   -dtb $TmpDir/rpi4.dtb \
#   -append "root=/dev/mmcblk1p2 rw console=tty1 console=ttyAMA0,115200 earlycon=pl011,mmio32,0xfe201000 rootwait $Init" \
#   -drive file="$Disk",format=raw,if=sd \
#   -netdev user,id=net0,hostfwd=tcp::2222-:22 \
#   -device usb-net,netdev=net0 \
#   -serial stdio -display gtk --no-reboot

# -----------------------------------------------------------------------------
# NEW QEMU -M virt Execution (Passing Physical Block Device via VirtIO)
# -----------------------------------------------------------------------------
# Note: sudo is required because QEMU needs raw read/write access to $Disk (/dev/sdX)
sudo qemu-system-aarch64 \
  -M virt \
  -cpu cortex-a72 \
  -smp 4 \
  -m 2G \
  -kernel "$TmpDir/Image" \
  -append "root=/dev/vda2 rw rootfstype=ext4 rootwait console=ttyAMA0 earlycon" \
  -drive file="$Disk",if=none,id=hd0,format=raw,file.locking=off \
  -device virtio-blk-pci,drive=hd0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device virtio-net-pci,netdev=net0 \
  -serial stdio \
  -display gtk,zoom-to-fit=on \
  --no-reboot
