#!/bin/bash
set -euo pipefail
case $(. /etc/os-release && echo $ID) in
arch)
  sudo pacman -S --needed --noconfirm dnsmasq arp-scan
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac
