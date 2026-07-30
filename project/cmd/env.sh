set -euo pipefail

if [[ "$0" == "$BASH_SOURCE" ]]; then
  echo "[-- source --]"
  exit 1
fi

source "environments/demo/env.sh"
