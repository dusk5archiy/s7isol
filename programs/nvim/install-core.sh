#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
ubuntu)
  sudo apt-get install -y --no-install-recommends \
    python3 python-is-python3 python3-venv \
    fd-find fzf ripgrep \
    g++ gcc make \
    git lazygit \
    neovim \
    npm \
    unzip \
    wl-clipboard

  sudo npm cache clean --force
  sudo npm install -g tree-sitter-cli
  sudo npm install -g neovim
  ;;
esac
