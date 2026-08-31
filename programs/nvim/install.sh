#!/bin/bash
set -euo pipefail

Step=${1:-0}

Dir=$(dirname "${BASH_SOURCE[0]}")

if [[ $Step == 0 || $Step == 1 ]]; then
  bash "$Dir/install-core.sh"
fi

if [[ $Step == 0 || $Step == 2 ]]; then
  bash "$Dir/lazy.sh"
  bash "$Dir/init.sh"
  bash "$Dir/dump.sh"

  nvim --headless "+Lazy! sync" +qa
fi

echo "[-- done --] ${BASH_SOURCE[0]}"
