#!/bin/bash
set -euo pipefail

. "$S7ISOL/commands/nvim/env.sh"
python "$S7ISOL/commands/nvim/lazyvim_dump.py"
