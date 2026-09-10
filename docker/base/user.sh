#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
ubuntu)
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gpg \
    less \
    wget \
    software-properties-common \
    tzdata \
    unzip \
    vim
  ;;
arch)
  sudo pacman -Syu --no-confirm
  sudo pacman -S --noconfirm --needed \
    ca-certificates \
    curl \
    git \
    gnupg \
    less \
    sudo \
    unzip \
    vim \
    wget \
    which
  ;;
esac

sudo git config --system http.sslVerify false
sudo git config --system --add safe.directory "*"
