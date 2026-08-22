#!/bin/bash
set -euo pipefail

. "$S7ISOL/commands/wezterm/env.sh"
s7_unset

wezterm start --cwd . >/dev/null 2>&1 &
disown
