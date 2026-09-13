#!/bin/bash

Main() {
  # ------------------------------------------------------------------------------
  local Target=${1:-}
  shift
  local Base="<|S7ISOL|>"
  local ScriptDirs=(scripts commands programs apps proj)

  # ------------------------------------------------------------------------------

  # shellcheck source=/dev/null
  . "<|S7ISOL|>/bin/init.sh"

  local BaseName && BaseName=$(basename "${BASH_SOURCE[0]}")
  export S7ISOL_TARGET="$BaseName $Target"

  # ------------------------------------------------------------------------------
  S7ISOL_PRE_ENV

  # ------------------------------------------------------------------------------

  # shellcheck disable=SC1091
  . "<|S7ISOL|>/bin/post.env.sh"

  # ------------------------------------------------------------------------------

  run_target() {
    for ScriptDir in "${ScriptDirs[@]}"; do
      local File=$Base/${ScriptDir}/${Target}.sh
      local FileInit=${Base}/${ScriptDir}/${Target}/__init__.sh
      local PythonFile=${Base}/${ScriptDir}/${Target}.py
      local ExecFile=""

      if [[ -f $File ]]; then
        ExecFile=$File
      elif [[ -f $FileInit ]]; then
        ExecFile=$FileInit
      fi

      if [[ -f $PythonFile ]]; then
        python "$PythonFile" "$@"
        return $?
      fi
      if [[ -f $ExecFile ]]; then
        if [[ $0 != "${BASH_SOURCE[0]}" ]]; then
          # shellcheck source=/dev/null
          . "$ExecFile" "$@"
        else
          bash "$ExecFile" "$@"
        fi
        return $?
      fi
    done

    echo "[-- error --] command not found" >&2
    return 127 # Target script not found
  }

  # ----------------------------------------------------------------------------

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
  Status=${?:-0}

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
}

Main "$@"
