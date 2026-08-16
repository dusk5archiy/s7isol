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
mkdir -p "$CONFIG_ENV_XDG_RUNTIME_DIR"
