#!/bin/bash
set -euo pipefail

skj python/install

case $(. /etc/os-release && echo "$ID") in
ubuntu)
  sudo apt-get install -y --no-install-recommends \
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
