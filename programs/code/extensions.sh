#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------

Dir=$(dirname "${BASH_SOURCE[0]}")

extensions=(
  ms-python.python                   # Python
  ms-python.black-formatter          # Python Black Formatter
  ms-toolsai.jupyter                 # Jupyter Notebook
  tomoki1207.pdf                     # PDF Viewer
  asvetliakov.vscode-neovim          # Neovim
  ms-vscode-remote.remote-containers # Dev Containers
  qufiwefefwoyn.kanagawa             # Kanagawa Colorscheme
  anthropic.claude-code              # Claude Code
)

for ext in "${extensions[@]}"; do
  echo "Installing extension: $ext"
  bash "$Dir/__init__.sh" --install-extension "$ext" --force
done

echo "[-- done --] ${BASH_SOURCE[0]}"
