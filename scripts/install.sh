#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------

packages=("$@")

if [[ ${#packages[@]} -eq 0 ]]; then
  return 1
fi

# ------------------------------------------------------------------------------

case $(. /etc/os-release && echo $ID) in
ubuntu)
  sudo apt-get install -y --no-install-recommends \
    "${packages[@]}"
  ;;
arch)
  sudo pacman -S --noconfirm --needed \
    "${packages[@]}"
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac
