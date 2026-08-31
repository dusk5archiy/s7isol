#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
ubuntu)
  sudo apt-get install -y --no-install-recommends xournalpp
  ;;
arch)
  sudo pacman -S --noconfirm --needed \
    xournalpp
  ;;
esac

echo "[-- done --] ${BASH_SOURCE[0]}"
