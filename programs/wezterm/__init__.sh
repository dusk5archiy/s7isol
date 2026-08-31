#!/bin/bash
set -euo pipefail

export WEZTERM_CONFIG_FILE=${WEZTERM_CONFIG_FILE:-"$S7ISOL/config/wezterm/main.lua"}
s7_unset

export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
export CONFIG_WEZTERM_DISPLAY=wayland
wezterm start --cwd . "$@" >/dev/null 2>&1 &
disown
