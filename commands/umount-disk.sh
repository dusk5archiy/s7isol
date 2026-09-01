#!/bin/bash
set -euo pipefail

Disk=${1:-}

if [[ -z $Disk || ! -b $Disk ]]; then
  echo "[-- invalid argument --]" >&2
  exit 1
fi

echo "Disk: $Disk"

sudo umount "${Disk}"* 2>/dev/null || true
