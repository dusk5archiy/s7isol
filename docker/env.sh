export CONFIG_PROJECT_NAME=s7isol

# ------------------------------------------------------------------------------

export CONFIG_USER_NAME=${1:-"skjuser"}
export CONFIG_WORKSPACE="/home/$CONFIG_USER_NAME/workspace"

# ------------------------------------------------------------------------------

export CONFIG_XDG_RUNTIME_DIR="/home/$CONFIG_USER_NAME/sockets"
export CONFIG_ENV_XDG_RUNTIME_DIR="XDG_RUNTIME_DIR=$CONFIG_XDG_RUNTIME_DIR"

export CONFIG_ENV_FALLBACK="$CONFIG_ENV_XDG_RUNTIME_DIR"
export CONFIG_MOUNT_FALLBACK=/dev/null:/dev/null

# ------------------------------------------------------------------------------

if [[ "$CONFIG_USER_NAME" == "skjuser" ]]; then export CONFIG_MOUNT_S7ISOL=".:/home/$CONFIG_USER_NAME/s7isol"; fi
if [[ -n "${XDG_SESSION_TYPE:-}" ]]; then export CONFIG_ENV_XDG_SESSION_TYPE="XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-}"; fi

# ------------------------------------------------------------------------------

HOST_XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-"/run/user/$(id -u)"}"

# X11 --------------------------------------------------------------------------

if [[ -n "${DISPLAY:-}" ]]; then export CONFIG_ENV_DISPLAY="DISPLAY=$DISPLAY"; fi

FROM_X11="/tmp/.X11-unix"
TO_X11="/tmp/.X11-unix"

if [[ -s "$FROM_X11" ]]; then export CONFIG_MOUNT_X11="$FROM_X11:$TO_X11:rw"; fi

# Wayland ----------------------------------------------------------------------

if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
  export CONFIG_ENV_WAYLAND_DISPLAY="WAYLAND_DISPLAY=$WAYLAND_DISPLAY"

  FROM_WAYLAND_SOCKET="$HOST_XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
  TO_WAYLAND_SOCKET="$CONFIG_XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"

  if [[ -S "$FROM_WAYLAND_SOCKET" ]]; then export CONFIG_MOUNT_WAYLAND_SOCKET="$FROM_WAYLAND_SOCKET:$TO_WAYLAND_SOCKET"; fi
fi

# Pipewire ---------------------------------------------------------------------

FROM_PIPEWIRE_SOCKET="$HOST_XDG_RUNTIME_DIR/pipewire-0"
TO_PIPEWIRE_SOCKET="$CONFIG_XDG_RUNTIME_DIR/pipewire-0"

if [[ -S "$FROM_PIPEWIRE_SOCKET" ]]; then export CONFIG_MOUNT_PIPEWIRE_SOCKET="$FROM_PIPEWIRE_SOCKET:$TO_PIPEWIRE_SOCKET"; fi

# Pulse ------------------------------------------------------------------------
#
FROM_PULSE_SOCKET="$HOST_XDG_RUNTIME_DIR/pulse"
TO_PULSE_SOCKET="$CONFIG_XDG_RUNTIME_DIR/pulse"

if [[ -d "$FROM_PULSE_SOCKET" ]]; then export CONFIG_MOUNT_PULSE_SOCKET="$FROM_PULSE_SOCKET:$TO_PULSE_SOCKET"; fi

# AI ---------------------------------------------------------------------------

if [[ -n "${ANTHROPIC_BASE_URL:-}" ]]; then export CONFIG_ENV_ANTHROPIC_BASE_URL="ANTHROPIC_BASE_URL=${ANTHROPIC_BASE_URL:-}"; fi
if [[ -n "${ANTHROPIC_AUTH_TOKEN:-}" ]]; then export CONFIG_ENV_ANTHROPIC_AUTH_TOKEN="ANTHROPIC_AUTH_TOKEN=${ANTHROPIC_AUTH_TOKEN:-}"; fi
if [[ -n "${ANTHROPIC_MODEL:-}" ]]; then export CONFIG_ENV_ANTHROPIC_MODEL="ANTHROPIC_MODEL=${ANTHROPIC_MODEL:-}"; fi
