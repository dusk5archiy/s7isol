#!/bin/bash
set -euo pipefail

Os=$(. /etc/os-release && echo $ID)

if [[ $Os != arch ]]; then
  echo '[-- error --] unsupported platform' >&2
  exit 1
fi

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed \
  sudo \
  less which vim \
  ca-certificates curl git gnupg wget unzip

sudo git config --system http.sslVerify false
sudo git config --system --add safe.directory "*"
