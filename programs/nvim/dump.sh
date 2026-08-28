#!/bin/bash
set -euo pipefail

Dir=$(dirname "${BASH_SOURCE[0]}")

. "$Dir/env.sh"
python "$Dir/lazyvim_dump.py"
