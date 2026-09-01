#!/bin/bash
set -euo pipefail

Disk=${1:-}
if [[ -z $Disk ]]; then
  echo "[-- error --] Please provide a disk device (/dev/sdX)."
  exit 1
fi
if [[ ! -b $Disk ]]; then
  echo "[-- error --] '$Disk' is not a block device."
  exit 1
fi

BackupDir=/mnt/z

sudo partclone.vfat -c -s "${Disk}1" -o $BackupDir/pi-boot.pcl
sudo partclone.ext4 -c -s "${Disk}2" -o $BackupDir/pi-root.pcl

echo "[-- done --] ${BASH_SOURCE[0]}"
