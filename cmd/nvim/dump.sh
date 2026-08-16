#!/bin/bash
set -euo pipefail

. "$S7ISOL/cmd/nvim/env.sh"
python "$S7ISOL/src/nvim/utils/lazyvim_dump.py"
