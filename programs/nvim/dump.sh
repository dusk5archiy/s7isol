#!/bin/bash
set -euo pipefail

_dir=$(dirname "${BASH_SOURCE[0]}")

. "$_dir/env.sh"
python "$_dir/lazyvim_dump.py"
