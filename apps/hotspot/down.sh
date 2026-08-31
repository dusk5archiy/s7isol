#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  sudo nmcli connection down Hotspot 2>/dev/null || true
  sudo nmcli connection delete Hotspot 2>/dev/null || true
  ;;
*)
  echo "[-- Error --] Unsupported OS."
  exit 1
  ;;
esac
