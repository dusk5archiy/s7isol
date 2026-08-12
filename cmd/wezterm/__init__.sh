#!/bin/bash

# ------------------------------------------------------------------------------

if [[ ! -f "/usr/bin/wezterm" ]]; then
  s7isol wezterm/install
fi

# ------------------------------------------------------------------------------

. "$S7ISOL/cmd/wezterm/env.sh"
s7_unset

wezterm start --cwd . >/dev/null 2>&1 &
disown
