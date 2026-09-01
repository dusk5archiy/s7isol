#!/bin/bash
set -euo pipefail

Port=${1:-}

if [[ -z $Port ]]; then
  echo "[-- error ] arg missing: Port"
  exit 1
fi

curl -I "http://localhost:$Port"
