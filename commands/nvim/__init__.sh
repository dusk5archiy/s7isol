#!/bin/bash
set -euo pipefail

if [[ -f "cmd/env.sh" ]]; then
  . "cmd/env.sh"
fi

if [[ -f "$S7ISOL/.claude.env" ]]; then
  . "$S7ISOL/.claude.env"
fi

. "$S7ISOL/commands/nvim/env.sh"
s7_unset

nvim ${@}
