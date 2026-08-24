#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
ubuntu)
  sudo apt-get install -y --no-install-recommends \
    thunar tumbler
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
