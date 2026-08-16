#!/bin/bash
set -euo pipefail

bash "$HOME/s7isol/install.sh" "$HOME"

PATH="$HOME/bin:$PATH"

skj wezterm/install
skj nvim/install
