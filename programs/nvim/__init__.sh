#!/bin/bash
set -euo pipefail

if [[ -f cmd/env.sh ]]; then
  # shellcheck disable=SC1091
  . cmd/env.sh
fi

Dir=$(dirname "${BASH_SOURCE[0]}")
. "$Dir/env.sh"
s7_unset

nvim "$@"
