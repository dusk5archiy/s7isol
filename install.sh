#!/bin/bash

CONFIG_HOME="${1:-"$HOME"}"

set -euo pipefail

# ------------------------------------------------------------------------------

if [[ "$0" != "$BASH_SOURCE" ]]; then
  echo "[-- no source --]"
  return 1
fi

# ------------------------------------------------------------------------------

source "$(dirname "$0")/bin/init.env.sh"
bash "$S7ISOL/scripts/new-exec.sh" "$CONFIG_HOME"
