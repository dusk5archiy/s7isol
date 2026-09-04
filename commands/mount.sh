#!/bin/bash
set -euo pipefail

Device=${1:-}
MountPoint=${2:-}

if [[ -z $Device || -z $MountPoint ]]; then
  echo "[-- invalid argument --]" >&2
  exit 1
fi

echo "Device: $Device"
echo "Mount point: $MountPoint"

FsType=$(lsblk -no FSTYPE "$Device" 2>/dev/null || true)

sudo mkdir -p "$MountPoint"
sudo chown "$USER:$USER" "$MountPoint"

if [[ $FsType == ntfs ]]; then
  sudo mount -t ntfs-3g "$Device" "$MountPoint"
else
  sudo mount "$Device" "$MountPoint"
fi
