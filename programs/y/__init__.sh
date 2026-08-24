#!/bin/bash
set -euo pipefail

# If you want to change directory while moving
# Please source this code

export YAZI_CONFIG_HOME=$S7ISOL/config/yazi
s7_unset

# This mechanism must be implemented in a function.
function y() {
  local tmp cwd
  tmp=$(mktemp -t yazi-cwd.XXXXXX)
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

y "$@"
