#!/bin/bash
set -euo pipefail

if [[ "$0" != "${BASH_SOURCE[0]}" ]]; then
  echo "[-- bash --]"
  return 1
fi

# ------------------------------------------------------------------------------

. "$S7ISOL/bin/post.env.sh"

/usr/bin/mkdir -p "$HOME" \
  "$XDG_CONFIG_HOME" \
  "$XDG_DATA_HOME" \
  "$XDG_CACHE_HOME" \
  "$XDG_STATE_HOME" \
  "$TMP"

/usr/bin/mkdir -p "$HOME/bin"
/usr/bin/mkdir -p "$HOME/.local/bin"
