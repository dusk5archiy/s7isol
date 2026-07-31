#!/bin/bash

set -euo pipefail

cd /tmp
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2604/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get install -y --no-install-recommends cuda-toolkit-13-3 libcudnn9-dev-cuda-13
sudo ln -snf /usr/include/x86_64-linux-gnu/cudnn*.h /usr/local/cuda/include/
sudo ln -snf /usr/lib/x86_64-linux-gnu/libcudnn* /usr/local/cuda/lib64/
sudo ln -snf /usr/local/cuda/lib64 /usr/local/cuda/lib
