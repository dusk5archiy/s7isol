#!/bin/bash

set -euo pipefail

if [[ "$0" != "$BASH_SOURCE" ]]; then
  echo "[-- bash --]"
  return 1
fi

# ------------------------------------------------------------------------------

source "/etc/environment"

# ------------------------------------------------------------------------------

source "$(dirname "$0")/bin/init.env.sh"
source "$S7ISOL/etc/init/pre.env.sh"

if [[ -z "$S7ISOL_ROOT" ]]; then
  echo "S7ISOL_ROOT is not set"
  exit 1
fi

/usr/bin/mkdir -p "$S7ISOL_ROOT"
export HOME="$S7ISOL_ROOT/home"
bash "$S7ISOL/scripts/new-exec.sh"
"$HOME/bin/skj" setup/post
"$HOME/bin/skj" setup/profile

# ------------------------------------------------------------------------------

s7_unset
"$HOME/bin/skj" wezterm
