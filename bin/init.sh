export SHELL=${SHELL:-/bin/bash}

function FnInit() {
  local Dir
  Dir=$(dirname "${BASH_SOURCE[0]}")
  S7ISOL=$(realpath "$Dir/..")
  export S7ISOL
}

FnInit
unset -f FnInit

function s7_unset() {
  local Vars
  Vars=$(printenv | awk -F= '/^S7ISOL/ {print $1}')
  if [[ -n $Vars ]]; then
    # shellcheck disable=SC2086
    unset $Vars
  fi
  unset -f s7_unset
  set +euo pipefail
  return 0
}

export -f s7_unset
