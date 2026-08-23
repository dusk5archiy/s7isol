#!/bin/bash
set -euo pipefail

. "$(dirname "$0")/bin/init.sh"
. "$S7ISOL/etc/init/pre.env.sh"
bash "$S7ISOL/scripts/new-exec.sh"

s7_unset
"$HOME/bin/skj" wezterm
