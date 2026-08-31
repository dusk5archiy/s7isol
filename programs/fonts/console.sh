#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  if [[ -f "/etc/vconsole.conf" ]]; then
    sudo pacman -S --noconfirm --needed terminus-font
    DefaultTerminalFont=ter-132n
    sudo sed -i "s/^FONT=.*/FONT=$DefaultTerminalFont/" /etc/vconsole.conf
  fi
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
