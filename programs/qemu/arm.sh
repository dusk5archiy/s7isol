#!/bin/bash
set -euo pipefail

ImageFile=${1:-}
if [[ -z $ImageFile || ! -f $ImageFile ]]; then
  echo "[-- error --] arg missing: ImageFile (.img)"
  exit 1
fi

TmpDir=/tmp/pi-boot
mkdir -p "$TmpDir"
rm -rf "${TmpDir:?}"/*
cp "$HOME/rpi-kernel-build/output/Image" "$TmpDir/Image"

qemu-system-aarch64 \
  -M virt \
  -cpu cortex-a72 \
  -smp 4 \
  -m 2G \
  -kernel "$TmpDir/Image" \
  -append "root=/dev/vda2 rw rootfstype=ext4 rootwait console=ttyAMA0 earlycon" \
  -drive file="$ImageFile",if=none,id=hd0,format=raw \
  -device virtio-blk-pci,drive=hd0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device virtio-net-pci,netdev=net0 \
  -serial stdio \
  -display gtk,zoom-to-fit=on \
  --no-reboot
