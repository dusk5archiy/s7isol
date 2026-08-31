#!/bin/bash
set -euo pipefail

my_docker_root=/mnt/docker/.my_docker_root
sudo mkdir -p /etc/docker "$my_docker_root"
sudo tee /etc/docker/daemon.json >/dev/null <<EOF
{
  "data-root": "${my_docker_root}",
  "features": {
    "containerd-snapshotter": false
  }
}
EOF

my_container_root=/mnt/docker/.my_container_root
sudo mkdir -p /etc/containerd "$my_container_root"
sudo tee /etc/containerd/config.toml >/dev/null <<EOF
version = 2
root = "$my_container_root"
EOF

echo "[-- done --] ${BASH_SOURCE[0]}"
