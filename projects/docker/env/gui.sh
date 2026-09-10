# X11 --------------------------------------------------------------------------
if [[ -n ${DISPLAY:-} ]]; then export CONFIG_ENV_DISPLAY=DISPLAY=$DISPLAY; fi

FromX11=/tmp/.X11-unix
ToX11=/tmp/.X11-unix
if [[ -s $FromX11 ]]; then export CONFIG_MOUNT_X11=$FromX11:$ToX11:rw; fi

# XDG Session ------------------------------------------------------------------
if [[ -n ${XDG_SESSION_TYPE:-} ]]; then export CONFIG_ENV_XDG_SESSION_TYPE=XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-}; fi

# XDG Runtime ------------------------------------------------------------------
ConfigUid=$(id -u)
HostXdgRuntimeDir=${XDG_RUNTIME_DIR:-/run/user/$ConfigUid}
ClientXdgRuntimeDir=/home/$CONFIG_USER_NAME/sockets
export CONFIG_XDG_RUNTIME_DIR=$ClientXdgRuntimeDir
export CONFIG_ENV_XDG_RUNTIME_DIR=XDG_RUNTIME_DIR=$ClientXdgRuntimeDir

# Wayland ----------------------------------------------------------------------
if [[ -n ${WAYLAND_DISPLAY:-} ]]; then
  export CONFIG_ENV_WAYLAND_DISPLAY=WAYLAND_DISPLAY=$WAYLAND_DISPLAY

  FromWaylandSocket=$HostXdgRuntimeDir/$WAYLAND_DISPLAY
  ToWaylandSocket=$ClientXdgRuntimeDir/$WAYLAND_DISPLAY
  if [[ -S $FromWaylandSocket ]]; then export CONFIG_MOUNT_WAYLAND_SOCKET=$FromWaylandSocket:$ToWaylandSocket; fi
fi

# Pipewire ---------------------------------------------------------------------
FromPipewireSocket=$HostXdgRuntimeDir/pipewire-0
ToPipewireSocket=$ClientXdgRuntimeDir/pipewire-0
if [[ -S $FromPipewireSocket ]]; then export CONFIG_MOUNT_PIPEWIRE_SOCKET=$FromPipewireSocket:$ToPipewireSocket; fi

# Pulse ------------------------------------------------------------------------
FromPulseSocket=$HostXdgRuntimeDir/pulse
ToPulseSocket=$ClientXdgRuntimeDir/pulse
if [[ -d $FromPulseSocket ]]; then export CONFIG_MOUNT_PULSE_SOCKET=$FromPulseSocket:$ToPulseSocket; fi
