#!/bin/bash
set -euo pipefail

wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

wget https://rstudio.org/download/latest/stable/desktop/jammy/rstudio-latest-amd64.deb -O /tmp/rstudio-latest-amd64.deb

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  r-base r-base-dev \
  /tmp/rstudio-latest-amd64.deb
