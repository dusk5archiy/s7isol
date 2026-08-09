#!/bin/bash

set -euo pipefail

skj python/install

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  sudo apt-get install -y --no-install-recommends \
    fd-find \
    fzf \
    g++ \
    gcc \
    git \
    lazygit \
    make \
    neovim-qt \
    npm \
    ripgrep \
    unzip \
    wl-clipboard

  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends neovim
  sudo npm cache clean --force
  sudo npm install -g tree-sitter-cli
  sudo npm install -g neovim
  ;;
esac
