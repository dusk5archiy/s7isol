#!/bin/bash
set -euo pipefail

Dir=$(dirname "${BASH_SOURCE[0]}")

bash "$Dir/install-core.sh"
bash "$Dir/lazy.sh"
bash "$Dir/init.sh"
bash "$Dir/dump.sh"

nvim --headless "+Lazy! sync" +qa
