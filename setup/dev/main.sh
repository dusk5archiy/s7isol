#!/bin/bash
set -euo pipefail

git clone https://github.com/dusk5archiy/s7isol.git "$HOME/s7isol"
bash "$HOME/s7isol/install.sh" "$HOME"

PATH="$HOME/bin:$PATH"

mkdir -p "$HOME/sockets"
skj wezterm/install
skj nvim/install
