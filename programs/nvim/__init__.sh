#!/bin/bash
set -euo pipefail

if [[ -f cmd/env.sh ]]; then
  . cmd/env.sh
fi

if [[ -f $S7ISOL/.claude.env ]]; then
  . "$S7ISOL/.claude.env"
fi

_dir=$(dirname "${BASH_SOURCE[0]}")

. "$_dir/env.sh"
s7_unset

export CONFIG_NVIM_TRANSPARENT=1
nvim "$@"
