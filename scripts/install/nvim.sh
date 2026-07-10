#!/bin/bash

# ------------------------------------------------------------------------------

case "$OS" in
ubuntu)
  sudo apt install python lazygit \
    fd-find fzf gcc g++ git ripgrep unzip npm wl-clipboard
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  sudo apt update
  sudo apt install neovim
  sudo npm cache clean --force
  sudo npm install -g tree-sitter-cli
  sudo npm install -g neovim
  ;;
esac
