#!/bin/bash
set -euo pipefail

wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  r-base r-base-dev

sudo snap install rstudio --classic
sudo apt-get install libcurl4-openssl-dev
