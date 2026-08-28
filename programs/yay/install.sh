#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  cd /tmp
  sudo pacman -S --noconfirm --needed git base-devel
  if [[ ! -d yay ]]; then git clone https://aur.archlinux.org/yay.git; fi
  cd yay
  makepkg -si
  cd ..
  rm -rf yay
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
