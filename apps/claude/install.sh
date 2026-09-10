#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
ubuntu)
  sudo npm -g install @anthropic-ai/claude-code
  claude install
  sudo npm -g uninstall @anthropic-ai/claude-code
  ;;
arch)
  yay -S --needed --noconfirm \
    claude-code
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac
