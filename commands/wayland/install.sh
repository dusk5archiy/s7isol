#!/bin/bash
set -euo pipefail

case "$(. /etc/os-release && echo "$ID")" in
ubuntu)
  # adwaita-icon-theme: helps Wezterm recognize mouse cursors
  sudo apt-get install -y --no-install-recommends \
    qt6-wayland \
    libqt6gui6 \
    libqt6opengl6 \
    adwaita-icon-theme
  ;;
esac
