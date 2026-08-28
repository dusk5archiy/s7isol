#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
ubuntu)
  wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
  sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    r-base r-base-dev

  sudo snap install rstudio --classic
  sudo apt-get install libcurl4-openssl-dev
  ;;
arch)
  sudo pacman -S --noconfirm --needed r
  yay -S rstudio-desktop-bin
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
