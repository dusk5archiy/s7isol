#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  yay -S --noconfirm --needed google-chrome
  ;;
esac
