#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  sudo pacman -S --noconfirm --needed \
    dnsmasq
  yay -S --noconfirm --needed \
    linux-wifi-hotspot
  ;;
esac
