#!/bin/bash
set -euo pipefail

Path=${1:-}
Size=${2:-}

if [[ -z $Path ]]; then
  echo "[-- error --] argument missing: Path" >&2
  exit 1
fi

if [[ -z $Size ]]; then
  echo "[-- error --] argument missing: Size (e.g. 16G)" >&2
  exit 1
fi

qemu-img create -f qcow2 "$Path" "$Size"
