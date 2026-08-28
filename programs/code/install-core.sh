#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------

case $(. /etc/os-release && echo $ID) in
ubuntu)
  sudo snap install --classic code
  ;;
arch)
  yay -S visual-studio-code-bin
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
