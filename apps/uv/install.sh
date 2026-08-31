#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
ubuntu)
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ;;
arch)
  sudo pacman -S --noconfirm --needed \
    uv
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac
