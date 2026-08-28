#!/bin/bash
set -euo pipefail

export WEZTERM_CONFIG_FILE=${WEZTERM_CONFIG_FILE:-"$S7ISOL/config/wezterm/main.lua"}
s7_unset

export CONFIG_WEZTERM_DISPLAY=wayland
wezterm start --cwd . >/dev/null 2>&1 &
disown
