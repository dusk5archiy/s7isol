export CONFIG_PROJECT_NAME="s7dev"

# Wayland ----------------------------------------------------------------------

export CONFIG_HOST_XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-"/run/user/$(id -u)"}"
export CONFIG_ENV_XDG_RUNTIME_DIR="/home/adevuser/sockets"
export CONFIG_ENV_WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-}"

export CONFIG_FROM_WAYLAND_SOCKET="$CONFIG_HOST_XDG_RUNTIME_DIR/$CONFIG_ENV_WAYLAND_DISPLAY"
export CONFIG_TO_WAYLAND_SOCKET="$CONFIG_ENV_XDG_RUNTIME_DIR/${CONFIG_ENV_WAYLAND_DISPLAY:-"wayland-0"}"

if [[ ! -S "$CONFIG_FROM_WAYLAND_SOCKET" ]]; then
  export CONFIG_FROM_WAYLAND_SOCKET="dummy_volume"
fi

# Wezterm ----------------------------------------------------------------------

export CONFIG_FROM_WEZTERM_SOCKET="${WEZTERM_UNIX_SOCKET:-}"
export CONFIG_TO_WEZTERM_SOCKET="$CONFIG_ENV_XDG_RUNTIME_DIR/wezterm.sock"

if [[ ! -S "$CONFIG_FROM_WEZTERM_SOCKET" ]]; then
  export CONFIG_FROM_WEZTERM_SOCKET="dummy_volume"
fi
