export CONFIG_PROJECT_NAME="s7isol"

# ------------------------------------------------------------------------------

export CONFIG_USER_NAME=${1:-"skjuser"}
export CONFIG_WORKSPACE="/home/$CONFIG_USER_NAME/workspace"
export CONFIG_ENV_XDG_RUNTIME_DIR="/home/$CONFIG_USER_NAME/sockets"

# ------------------------------------------------------------------------------

export CONFIG_HOST_XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-"/run/user/$(id -u)"}"

# X11 --------------------------------------------------------------------------

export CONFIG_ENV_DISPLAY="${DISPLAY:-":0"}"

# Wayland ----------------------------------------------------------------------

export CONFIG_ENV_WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-}"

export CONFIG_FROM_WAYLAND_SOCKET="$CONFIG_HOST_XDG_RUNTIME_DIR/$CONFIG_ENV_WAYLAND_DISPLAY"
export CONFIG_TO_WAYLAND_SOCKET="$CONFIG_ENV_XDG_RUNTIME_DIR/${CONFIG_ENV_WAYLAND_DISPLAY:-"wayland-0"}"

if [[ ! -S "$CONFIG_FROM_WAYLAND_SOCKET" ]]; then
  export CONFIG_FROM_WAYLAND_SOCKET="dummy_volume"
fi

# AI ---------------------------------------------------------------------------

export CONFIG_ENV_ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL:-}"
export CONFIG_ENV_ANTHROPIC_AUTH_TOKEN="${ANTHROPIC_AUTH_TOKEN:-}"
export CONFIG_ENV_ANTHROPIC_MODEL="${ANTHROPIC_MODEL:-}"
