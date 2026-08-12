#!/bin/bash

# If you want to change directory while moving
# Please source this code

. "$S7ISOL/cmd/yazi/env.sh"
s7_unset

# This mechanism must be implemented in a function.
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

y
