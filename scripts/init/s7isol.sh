#!/bin/bash

# ------------------------------------------------------------------------------

S7ISOL_EXECUTABLE="$HOME/bin/s7isol"

# ------------------------------------------------------------------------------

if [[ ! -f "$S7ISOL_EXECUTABLE" || -n "$FORCE_INIT" ]]; then
  /usr/bin/mkdir -p "$HOME/bin"
  /usr/bin/rm -f "$S7ISOL_EXECUTABLE"
  /usr/bin/touch "$S7ISOL_EXECUTABLE"
  /usr/bin/cat "$S7ISOL/bin/s7isol.sh" >>"$S7ISOL_EXECUTABLE"
  /usr/bin/chmod +x "$S7ISOL_EXECUTABLE"
fi
