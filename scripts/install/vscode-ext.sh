#!/bin/bash

# ------------------------------------------------------------------------------

extensions=(
  "ms-python.python"                   # Python
  "ms-python.black-formatter"          # Python Black Formatter
  "ms-toolsai.jupyter"                 # Jupyter Notebook
  "tomoki1207.pdf"                     # PDF Viewer
  "asvetliakov.vscode-neovim"          # Neovim
  "ms-vscode-remote.remote-containers" # Dev Containers
  "qufiwefefwoyn.kanagawa"             # Kanagawa Colorscheme
)

for ext in "${extensions[@]}"; do
  echo "Installing extension: $ext"
  code --install-extension "$ext"
done

echo "Done!"
