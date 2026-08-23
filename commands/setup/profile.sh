#!/bin/bash
set -euo pipefail

if [[ "$0" != "${BASH_SOURCE[0]}" ]]; then
  echo "[-- bash --]"
  return 1
fi

# ------------------------------------------------------------------------------

PROFILE_FILE="$HOME/.profile"
/usr/bin/cat "$S7ISOL/etc/start/.profile" >"$PROFILE_FILE"

# ------------------------------------------------------------------------------

BASHRC_FILE="$HOME/.bashrc"
/usr/bin/cat "$S7ISOL/etc/start/bashrc-ubuntu.sh" >"$BASHRC_FILE"
/usr/bin/cat "$S7ISOL/etc/start/bashrc-final.sh" >>"$BASHRC_FILE"
