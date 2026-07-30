#!/usr/bin/env bash

set -e

# ------------------------------------------------------------------------------

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  sudo apt install python3 python-is-python3 lazygit \
    fd-find fzf gcc g++ git ripgrep unzip npm wl-clipboard neovim-qt
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  sudo apt update
  sudo apt install neovim
  sudo npm cache clean --force
  sudo npm install -g tree-sitter-cli
  sudo npm install -g neovim
  ;;
esac
