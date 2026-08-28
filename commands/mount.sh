#!/bin/bash
set -euo pipefail

Device=$1
MountPoint=$2

if [[ -z $Device || -z $MountPoint ]]; then
  echo "[-- invalid argument --]" >&2
  exit 1
fi

echo "Device: $Device"
echo "Mount point: $MountPoint"

sudo mkdir -p "$MountPoint"
sudo chown "$USER:$USER" "$MountPoint"
sudo mount "$Device" "$MountPoint"
