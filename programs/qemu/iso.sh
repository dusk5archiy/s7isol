#!/bin/bash
set -euo pipefail

ImageFile=${1:-}

if [[ -z $ImageFile || ! -f $ImageFile ]]; then
  echo "[-- error --] arg missing: ImageFile (.iso)"
  exit 1
fi

sudo qemu-system-x86_64 \
  -accel kvm \
  -cpu host \
  -m 6G \
  -smp 6 \
  -cdrom "$ImageFile" \
  -boot d \
  -usb -device usb-mouse -device usb-kbd \
  -display gtk,zoom-to-fit=on
