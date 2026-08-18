#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------

target="${1:-}"
shift # Remove $1 so "$@" holds only the remaining arguments
base="<|S7ISOL|>"
dirs=("scripts" "cmd" "apps" "proj")

# ------------------------------------------------------------------------------

. "<|S7ISOL|>/bin/init.sh"

# ------------------------------------------------------------------------------
S7ISOL_PRE_ENV

# ------------------------------------------------------------------------------

. "<|S7ISOL|>/bin/post.env.sh"

# ------------------------------------------------------------------------------

run_target() {
  for dir in "${dirs[@]}"; do
    local file="$base/$dir/$target.sh"
    local file_init="$base/$dir/$target/__init__.sh"
    local exec_file=""

    if [[ -f "$file" ]]; then
      exec_file="$file"
    elif [[ -f "$file_init" ]]; then
      exec_file="$file_init"
    fi

    if [[ -n "$exec_file" ]]; then
      if [[ "$0" != "$BASH_SOURCE" ]]; then
        . "$exec_file" "$@"
      else
        bash "$exec_file" "$@"
      fi
      return "$?"
    fi
  done

  return 127 # Target script not found
}

# ------------------------------------------------------------------------------

# 1. Handle empty target
if [[ -z "$target" ]]; then
  echo "$S7ISOL"
  s7_unset
  if [[ "$0" != "$BASH_SOURCE" ]]; then
    return 0
  else
    exit 0
  fi
fi

# 2. Execute target dispatch
run_target "$@"
status="$?"

# 3. Clean up
s7_unset

# 4. Exit/Return based on invocation mode using the captured exit status
if [[ "$0" != "$BASH_SOURCE" ]]; then
  return "$status"
else
  exit "$status"
fi
