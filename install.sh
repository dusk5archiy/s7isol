#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------

if [[ "$0" != "$BASH_SOURCE" ]]; then
  echo "[-- no source --]"
  return 1
fi

# ------------------------------------------------------------------------------

. "$(dirname "$0")/bin/init.env.sh"
bash "$S7ISOL/scripts/new-exec.sh"
"$HOME/bin/skj" setup/post
"$HOME/bin/skj" setup/profile
