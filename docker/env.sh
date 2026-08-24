# change #######################################################################
export CONFIG_PROJECT_NAME=s7isol
# ##############################################################################

# Arguments --------------------------------------------------------------------

export CONFIG_CONTEXT=$PWD
export CONFIG_DOCKERFILE=$PWD/docker/Dockerfile
export CONFIG_USER_NAME=skjuser
CONFIG_UID=$(id -u)

# XDG Runtime ------------------------------------------------------------------

HOST_XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$CONFIG_UID}
CLIENT_XDG_RUNTIME_DIR=/home/$CONFIG_USER_NAME/sockets
export CONFIG_XDG_RUNTIME_DIR=$CLIENT_XDG_RUNTIME_DIR
export CONFIG_ENV_XDG_RUNTIME_DIR=XDG_RUNTIME_DIR=$CLIENT_XDG_RUNTIME_DIR

# Workspae ---------------------------------------------------------------------

FROM_WORKSPACE=$CONFIG_CONTEXT
TO_WORKSPACE=/home/$CONFIG_USER_NAME/workspace
export CONFIG_WORKSPACE=$TO_WORKSPACE
export CONFIG_MOUNT_WORKSPACE=$FROM_WORKSPACE:$TO_WORKSPACE

# mold #########################################################################
export CONFIG_MOUNT_S7ISOL=$FROM_WORKSPACE:"/home/$CONFIG_USER_NAME/s7isol"
# ##############################################################################

# Fallbacks --------------------------------------------------------------------

export CONFIG_ENV_FALLBACK=$CONFIG_ENV_XDG_RUNTIME_DIR
export CONFIG_MOUNT_FALLBACK=/dev/null:/dev/null

# XDG Session ------------------------------------------------------------------

if [[ -n ${XDG_SESSION_TYPE:-} ]]; then export CONFIG_ENV_XDG_SESSION_TYPE=XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-}; fi

# X11 --------------------------------------------------------------------------

if [[ -n ${DISPLAY:-} ]]; then export CONFIG_ENV_DISPLAY=DISPLAY=$DISPLAY; fi

FROM_X11=/tmp/.X11-unix
TO_X11=/tmp/.X11-unix
if [[ -s $FROM_X11 ]]; then export CONFIG_MOUNT_X11=$FROM_X11:$TO_X11:rw; fi

# Wayland ----------------------------------------------------------------------

if [[ -n ${WAYLAND_DISPLAY:-} ]]; then
  export CONFIG_ENV_WAYLAND_DISPLAY=WAYLAND_DISPLAY=$WAYLAND_DISPLAY

  FROM_WAYLAND_SOCKET=$HOST_XDG_RUNTIME_DIR/$WAYLAND_DISPLAY
  TO_WAYLAND_SOCKET=$CLIENT_XDG_RUNTIME_DIR/$WAYLAND_DISPLAY
  if [[ -S $FROM_WAYLAND_SOCKET ]]; then export CONFIG_MOUNT_WAYLAND_SOCKET=$FROM_WAYLAND_SOCKET:$TO_WAYLAND_SOCKET; fi
fi

# Pipewire ---------------------------------------------------------------------

FROM_PIPEWIRE_SOCKET=$HOST_XDG_RUNTIME_DIR/pipewire-0
TO_PIPEWIRE_SOCKET=$CLIENT_XDG_RUNTIME_DIR/pipewire-0
if [[ -S $FROM_PIPEWIRE_SOCKET ]]; then export CONFIG_MOUNT_PIPEWIRE_SOCKET=$FROM_PIPEWIRE_SOCKET:$TO_PIPEWIRE_SOCKET; fi

# Pulse ------------------------------------------------------------------------
#
FROM_PULSE_SOCKET=$HOST_XDG_RUNTIME_DIR/pulse
TO_PULSE_SOCKET=$CLIENT_XDG_RUNTIME_DIR/pulse
if [[ -d $FROM_PULSE_SOCKET ]]; then export CONFIG_MOUNT_PULSE_SOCKET=$FROM_PULSE_SOCKET:$TO_PULSE_SOCKET; fi

# AI ---------------------------------------------------------------------------

if [[ -n ${ANTHROPIC_BASE_URL:-} ]]; then export CONFIG_ENV_ANTHROPIC_BASE_URL=ANTHROPIC_BASE_URL=${ANTHROPIC_BASE_URL:-}; fi
if [[ -n ${ANTHROPIC_AUTH_TOKEN:-} ]]; then export CONFIG_ENV_ANTHROPIC_AUTH_TOKEN=ANTHROPIC_AUTH_TOKEN=${ANTHROPIC_AUTH_TOKEN:-}; fi
if [[ -n ${ANTHROPIC_MODEL:-} ]]; then export CONFIG_ENV_ANTHROPIC_MODEL=ANTHROPIC_MODEL=${ANTHROPIC_MODEL:-}; fi

# Claude -----------------------------------------------------------------------

FROM_CLAUDE=$PWD/docker/.mounts/.claude
TO_CLAUDE=/home/$CONFIG_USER_NAME/.claude
if [[ ! -d $FROM_CLAUDE ]]; then mkdir -p "$FROM_CLAUDE"; fi
export CONFIG_MOUNT_CLAUDE=$FROM_CLAUDE:$TO_CLAUDE
