#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
ubuntu)
  if ! command -v docker &>/dev/null; then
    # Add Docker's official GPG key:
    sudo apt-get install -y --no-install-recommends ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

    sudo apt-get update
    sudo apt-get install -y --no-install-recommends \
      docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
      util-linux-extra
  fi
  ;;
arch)
  sudo pacman -S --noconfirm --needed \
    docker docker-compose docker-buildx \
    nvidia-container-toolkit
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac

sudo nvidia-ctk runtime configure --runtime=docker
