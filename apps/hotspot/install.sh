#!/bin/bash
set -euo pipefail
case $(. /etc/os-release && echo $ID) in
arch)
  sudo pacman -S --needed --noconfirm dnsmasq arp-scan
  ;;
*)
  echo "[-- error --] unsupported platform"
  exit 1
  ;;
esac
