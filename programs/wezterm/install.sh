#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
ubuntu)
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
  sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
  sudo apt-get update

  sudo apt-get install -y --no-install-recommends \
    wezterm
  ;;
arch)
  sudo pacman -S --noconfirm --needed \
    wezterm libgit2
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
