#!/bin/bash
set -euo pipefail

Dir=$(dirname "${BASH_SOURCE[0]}")

bash "$Dir/install.sh"
"$HOME/bin/skj" wezterm
