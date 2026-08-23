#!/bin/bash
set -euo pipefail

# Install NVIDIA Container Toolkit
sudo apt-get install -y --no-install-recommends nvidia-container-toolkit

# Configure Docker to use the NVIDIA runtime
sudo nvidia-ctk runtime configure --runtime=docker

# Restart the Docker daemon
sudo systemctl restart docker
