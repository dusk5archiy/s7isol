#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  sudo pacman -S --noconfirm --needed \
    libreoffice-fresh
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac

echo "[-- done --] ${BASH_SOURCE[0]}"
