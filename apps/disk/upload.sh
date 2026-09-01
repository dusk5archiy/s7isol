#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  ;;
esac

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

sudo partclone.restore -s $BackupDir/pi-boot.pcl -o "${Disk}1"
sudo partclone.restore -s $BackupDir/pi-root.pcl -o "${Disk}2"

echo "[-- done --] ${BASH_SOURCE[0]}"
