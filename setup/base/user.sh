#!/bin/bash
set -euo pipefail

# Essentials -------------------------------------------------------------------
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  gpg \
  wget \
  tzdata \
  vim

# ------------------------------------------------------------------------------

mkdir -p "$CONFIG_WORKSPACE"
