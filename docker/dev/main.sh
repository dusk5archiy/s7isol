#!/bin/bash
set -euo pipefail

bash "$HOME/s7isol/install.sh" "$HOME"

PATH="$HOME/bin:$PATH"

case $(. /etc/os-release && echo "$OS") in
ubuntu)
  sudo apt-get update
  ;;
esac

skj nvim/install
