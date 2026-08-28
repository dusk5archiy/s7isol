#!/bin/bash
set -euo pipefail

if [[ -f cmd/env.sh ]]; then
  . cmd/env.sh
fi

Dir=$(dirname "${BASH_SOURCE[0]}")
. "$Dir/env.sh"
s7_unset

export CONFIG_NVIM_TRANSPARENT=1
nvim "$@"
