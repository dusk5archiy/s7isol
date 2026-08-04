#!/bin/bash

set -euo pipefail

CONFIG_PROJECT_NAME="s7dev"

# 1. Safely evaluate variables with fallback defaults to satisfy 'set -u'
HOST_XDG_RUNTIME="${XDG_RUNTIME_DIR:-}"
CONFIG_WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-"wayland-0"}"

# 2. Build the Wayland socket path using the evaluated display name
CONFIG_WAYLAND_SOCKET="${HOST_XDG_RUNTIME}/${CONFIG_WAYLAND_DISPLAY}"

# 3. Check if host paths are valid socket files; fallback to dummy_volume if not
if [[ ! -S "$CONFIG_WEZTERM_SOCKET" ]]; then
  CONFIG_WEZTERM_SOCKET="dummy_volume"
fi

# Wezterm (

CONFIG_WEZTERM_SOCKET="${WEZTERM_UNIX_SOCKET:-}"

if [[ ! -S "$CONFIG_WAYLAND_SOCKET" ]]; then
  CONFIG_WAYLAND_SOCKET="dummy_volume"
fi

# Wezterm )

sudo \
  CONFIG_PROJECT_NAME="$CONFIG_PROJECT_NAME" \
  CONFIG_WAYLAND_DISPLAY="$CONFIG_WAYLAND_DISPLAY" \
  CONFIG_WEZTERM_SOCKET="$CONFIG_WEZTERM_SOCKET" \
  CONFIG_WAYLAND_SOCKET="$CONFIG_WAYLAND_SOCKET" \
  "$@"
