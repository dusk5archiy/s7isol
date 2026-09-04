#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------

Target=${1:-}
shift # Remove $1 so "$@" holds only the remaining arguments
Base="<|S7ISOL|>"
Dirs=(scripts commands programs apps proj)

# ------------------------------------------------------------------------------

# shellcheck disable=SC1091
. "<|S7ISOL|>/bin/init.sh"

BaseName=$(basename "${BASH_SOURCE[0]}")
export S7ISOL_TARGET="$BaseName $Target"

# ------------------------------------------------------------------------------
S7ISOL_PRE_ENV

# ------------------------------------------------------------------------------

# shellcheck disable=SC1091
. "<|S7ISOL|>/bin/post.env.sh"

# ------------------------------------------------------------------------------

run_target() {
  for Dir in "${Dirs[@]}"; do
    local File=$Base/$Dir/$Target.sh
    local FileInit=$Base/$Dir/$Target/__init__.sh
    local ExecFile=""

    if [[ -f $File ]]; then
      ExecFile=$File
    elif [[ -f $FileInit ]]; then
      ExecFile=$FileInit
    fi

    if [[ -n $ExecFile ]]; then
      if [[ $0 != "${BASH_SOURCE[0]}" ]]; then
        # shellcheck disable=SC1090
        . "$ExecFile" "$@"
      else
        bash "$ExecFile" "$@"
      fi
      return $?
    fi
  done

  return 127 # Target script not found
}

# ------------------------------------------------------------------------------

# 1. Handle empty target
if [[ -z $Target ]]; then
  echo "$S7ISOL"
  s7_unset
  if [[ $0 != "${BASH_SOURCE[0]}" ]]; then
    return 0
  else
    exit 0
  fi
fi

# 2. Execute target dispatch
run_target "$@"
Status="$?"

# 3. Clean up
if declare -f s7_unset &>/dev/null; then
  s7_unset
fi

# 4. Exit/Return based on invocation mode using the captured exit status
if [[ $0 != "${BASH_SOURCE[0]}" ]]; then
  return "$Status"
else
  exit "$Status"
fi
