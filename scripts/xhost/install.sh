#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
ubuntu)
  ;;
arch)
  sudo pacman -S --noconfirm --needed \
    xorg-xhost
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
