#!/bin/bash
set -euo pipefail

SocketPath="/tmp/virtiofsd.sock"
SockPidFile="${SocketPath}.pid"
PidFile="/tmp/virtiofsd.pid"
DirFile="/tmp/virtiofsd.dir"

Main() {
  local Stopped=false

  # Try PID from virtiofsd's socket PID file first
  if [[ -f "$SockPidFile" ]]; then
    local Pid
    Pid=$(cat "$SockPidFile" 2>/dev/null || true)
    if [[ -n "$Pid" ]] && kill -0 "$Pid" 2>/dev/null; then
      echo "[-- info --] killing virtiofsd (PID: $Pid)..."
      kill "$Pid" 2>/dev/null || true
      Stopped=true
    fi
  fi

  # Try PID from wrapper PID file
  if [[ -f "$PidFile" ]]; then
    local Pid
    Pid=$(cat "$PidFile" 2>/dev/null || true)
    if [[ -n "$Pid" ]] && kill -0 "$Pid" 2>/dev/null; then
      kill "$Pid" 2>/dev/null || true
      Stopped=true
    fi
  fi

  # Ensure no orphan virtiofsd process is running
  if pgrep -f "virtiofsd" &>/dev/null; then
    pkill -f "virtiofsd" 2>/dev/null || true
    Stopped=true
  fi

  # Clean up socket and PID files
  rm -f "$SocketPath" "$SockPidFile" "$PidFile" "$DirFile" 2>/dev/null || true

  if [[ "$Stopped" == true ]]; then
    echo "[-- done --] virtiofsd stopped and cleaned up"
  else
    echo "[-- info --] virtiofsd was not running"
  fi
}

Main "$@"
