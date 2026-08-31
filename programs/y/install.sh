#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
ubuntu)
  curl -fsSL https://yazi-rs.github.io/builds/yazi-keyring.gpg | sudo tee /usr/share/keyrings/yazi-keyring.gpg >/dev/null
  echo 'deb [signed-by=/usr/share/keyrings/yazi-keyring.gpg] https://yazi-rs.github.io/builds/ stable main' | sudo tee /etc/apt/sources.list.d/yazi.list >/dev/null
  sudo apt-get update &&
    sudo apt-get -y --no-install-recommends install yazi
  ;;
arch)
  sudo pacman -S --noconfirm --needed \
    yazi
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac

echo "[-- done --] ${BASH_SOURCE[0]}"
