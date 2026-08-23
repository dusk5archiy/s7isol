#!/bin/bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  gpg \
  wget \
  software-properties-common \
  tzdata \
  unzip \
  vim
