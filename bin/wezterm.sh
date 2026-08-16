#!/bin/bash
set -euo pipefail

export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json

export WEZTERM_CONFIG_FILE="$PWD/config/wezterm/main.lua"
export CONFIG_WEZTERM_THEME="Django"
wezterm start --cwd . >/dev/null 2>&1 &
disown
