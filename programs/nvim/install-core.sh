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
  ;;
arch)
  sudo pacman -S --noconfirm --needed \
    python \
    fd fzf ripgrep \
    gcc make \
    git lazygit \
    neovim \
    npm \
    unzip \
    wl-clipboard
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac

sudo npm install -g tree-sitter-cli --allow-scripts=tree-sitter-cli
sudo npm install -g neovim

echo "[-- done --] ${BASH_SOURCE[0]}"
