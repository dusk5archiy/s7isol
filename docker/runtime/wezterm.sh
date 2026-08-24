#!/bin/bash
set -euo pipefail

export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json

export WEZTERM_CONFIG_FILE="$HOME/s7isol/config/wezterm/main.lua"
export CONFIG_WEZTERM_THEME="Catppuccin Mocha"
export CONFIG_WEZTERM_DISPLAY="wayland"
export CONFIG_NVIM_THEME="catppuccin"
wezterm start --cwd . >/dev/null 2>&1 &
disown
