#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
ubuntu)
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gpg \
    less \
    wget \
    software-properties-common \
    tzdata \
    unzip \
    vim
  ;;
arch)
  sudo pacman -Syu
  sudo pacman -S --noconfirm --needed \
    ca-certificates curl gnupg less \
    wget unzip vim which
  ;;
esac
