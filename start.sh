#!/bin/bash
set -euo pipefail

. /etc/environment

Dir=$(dirname "${BASH_SOURCE[0]}")

# ------------------------------------------------------------------------------
. "$Dir/bin/init.sh"
. "$Dir/etc/init/pre.env.sh"

if [[ -z $S7ISOL_ROOT ]]; then
  echo "S7ISOL_ROOT is not set"
  exit 1
fi

mkdir -p "$S7ISOL_ROOT"
export HOME=$S7ISOL_ROOT/home
s7_unset
# ------------------------------------------------------------------------------

bash "$Dir/install.sh" --profile
"$HOME/bin/skj" wezterm
