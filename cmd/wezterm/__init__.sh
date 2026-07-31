#!/bin/bash

# ------------------------------------------------------------------------------

if [[ ! -f "/usr/bin/wezterm" ]]; then
  s7isol wezterm/install
fi

# ------------------------------------------------------------------------------

s7_unset
/usr/bin/wezterm start --cwd . >/dev/null 2>&1 &
disown
