#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  sudo pacman -S --noconfirm --needed \
    ttf-jetbrains-mono-nerd noto-fonts-cjk noto-fonts-emoji
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
