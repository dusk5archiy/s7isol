#!/bin/bash
set -euo pipefail

if [[ $0 != "${BASH_SOURCE[0]}" ]]; then
  echo "[-- bash --]"
  return 1
fi

# ------------------------------------------------------------------------------

_profile_file=$HOME/.profile
/usr/bin/cat "$S7ISOL/etc/start/.profile" >"$_profile_file"

# ------------------------------------------------------------------------------

_bashrc_file=$HOME/.bashrc
/usr/bin/cat "$S7ISOL/etc/start/bashrc-ubuntu.sh" >"$_bashrc_file"
/usr/bin/cat "$S7ISOL/etc/start/bashrc-final.sh" >>"$_bashrc_file"
