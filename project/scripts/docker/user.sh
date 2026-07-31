#!/bin/bash

set -euo pipefail

git clone https://github.com/dusk5archiy/s7isol.git "$HOME/s7isol"
bash "$HOME/s7isol/install.sh" "$HOME"
PATH="$HOME/bin:$PATH"

skj wezterm/install
skj ssh-server/install
