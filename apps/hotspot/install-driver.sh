#!/bin/bash
set -euo pipefail
case $(. /etc/os-release && echo $ID) in
arch)
  yay -S --noconfirm rtl88x2bu-dkms-git
  sudo modprobe -r rtw88_8822bu
  sudo modprobe -r 88x2bu
  sudo modprobe 88x2bu
  ;;
*)
  echo "[-- error --] unsupported platform"
  exit 1
  ;;
esac
