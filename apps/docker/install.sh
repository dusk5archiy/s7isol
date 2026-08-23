#!/bin/bash
set -euo pipefail

if ! command -v docker &>/dev/null; then
  case $(. /etc/os-release && echo "$ID") in
  ubuntu)
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
      docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl start docker
    sudo systemctl enable docker
    ;;
  esac
fi

if ! command -v newgrp &>/dev/null; then
  sudo apt-get install util-linux-extra
fi

user=$(whoami)
echo "Adding $user to group docker..."
sudo groupadd docker &>/dev/null
sudo usermod -aG docker "$user"
newgrp docker
