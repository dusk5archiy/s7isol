#!/bin/bash
set -euo pipefail

SocketPath="/tmp/virtiofsd.sock"
SockPidFile="${SocketPath}.pid"
PidFile="/tmp/virtiofsd.pid"
DirFile="/tmp/virtiofsd.dir"
LogFile="/tmp/virtiofsd.log"

Main() {
  local ShareDir="${1:-}"

  if [[ -z "$ShareDir" ]]; then
    echo "[-- error --] missing directory argument" >&2
    echo "Usage: $0 <path_to_directory>" >&2
    return 1
  fi

  if [[ ! -d "$ShareDir" ]]; then
    echo "[-- error --] directory does not exist: $ShareDir" >&2
    return 1
  fi

  ShareDir=$(realpath "$ShareDir")

  # Find virtiofsd binary
  local VirtiofsdBin=""
  if command -v virtiofsd &>/dev/null; then
    VirtiofsdBin=$(command -v virtiofsd)
  elif [[ -x /usr/lib/virtiofsd ]]; then
    VirtiofsdBin="/usr/lib/virtiofsd"
  elif [[ -x /usr/libexec/virtiofsd ]]; then
    VirtiofsdBin="/usr/libexec/virtiofsd"
  else
    echo "[-- error --] virtiofsd executable not found" >&2
    return 1
  fi

  # Stop any existing instance
  if [[ -f "$SockPidFile" ]]; then
    local OldPid
    OldPid=$(cat "$SockPidFile" 2>/dev/null || true)
    if [[ -n "$OldPid" ]] && kill -0 "$OldPid" 2>/dev/null; then
      echo "[-- info --] stopping existing virtiofsd (PID: $OldPid)..."
      kill "$OldPid" 2>/dev/null || true
      sleep 0.3
    fi
  fi

  if pgrep -f "$VirtiofsdBin" &>/dev/null; then
    pkill -f "$VirtiofsdBin" 2>/dev/null || true
  fi

  rm -f "$SocketPath" "$SockPidFile" "$PidFile" 2>/dev/null || true

  # Start virtiofsd
  echo "[-- info --] starting virtiofsd for directory: $ShareDir"
  nohup "$VirtiofsdBin" \
    --socket-path="$SocketPath" \
    --shared-dir="$ShareDir" \
    --announce-submounts \
    >"$LogFile" 2>&1 &

  local Pid=$!
  disown "$Pid" 2>/dev/null || true
  echo "$Pid" >"$PidFile"
  echo "$ShareDir" >"$DirFile"

  # Wait for socket to become ready
  local Ready=false
  for _ in {1..30}; do
    if [[ -S "$SocketPath" ]]; then
      Ready=true
      break
    fi
    sleep 0.1
  done

  if [[ "$Ready" == true ]]; then
    chmod 666 "$SocketPath" 2>/dev/null || true
    echo "[-- done --] virtiofsd started successfully (PID: $Pid, socket: $SocketPath)"
    echo "[-- info --] sharing: $ShareDir"
  else
    echo "[-- error --] failed to start virtiofsd. Check log: $LogFile" >&2
    return 1
  fi
}

Main "$@"
