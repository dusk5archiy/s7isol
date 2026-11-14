Main() {
  local MyDockerRoot=/mnt/docker/.my_docker_root
  sudo mkdir -p /etc/docker "$MyDockerRoot"
  sudo tee /etc/docker/daemon.json >/dev/null <<EOF
{
  "data-root": "${MyDockerRoot}",
  "features": {
    "containerd-snapshotter": false
  }
}
EOF

  local MyContainerRoot=/mnt/docker/.my_container_root
  sudo mkdir -p /etc/containerd "$MyContainerRoot"
  sudo tee /etc/containerd/config.toml >/dev/null <<EOF
version = 2
root = "$MyContainerRoot"
EOF
}

Main
echo "[-- done --] ${BASH_SOURCE[0]}"
