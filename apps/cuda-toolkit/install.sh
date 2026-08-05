#!/bin/bash

set -euo pipefail

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  cd /tmp
  wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2604/x86_64/cuda-keyring_1.1-1_all.deb
  sudo dpkg -i cuda-keyring_1.1-1_all.deb
  sudo apt-get update &&
    sudo apt-get install -y --no-install-recommends cuda-toolkit-13-3 cudnn9-cuda-13 cudnn9-jit-cuda-13
  ;;
esac
