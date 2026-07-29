#!/usr/bin/env bash

set -euo pipefail

# ------------------------------------------------------------------------------

if [[ "$0" != "$BASH_SOURCE" ]]; then
  return 1
fi

# ------------------------------------------------------------------------------

source "$(dirname "$0")/bin/init.env.sh"
source "$S7ISOL/bin/pre.env.sh"
source "$S7ISOL/etc/init/pre.env.sh"
bash "$S7ISOL/scripts/new-exec.sh"
s7_unset

# ------------------------------------------------------------------------------

"$HOME/bin/skj" wezterm
