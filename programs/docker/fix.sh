#!/bin/bash
set -euo pipefail

echo "=================================================="
echo "Starting Clean Docker & Containerd Restart..."
echo "=================================================="

# 1. Stop the main systemd services
echo "-> Stopping Docker and containerd services..."
sudo systemctl stop docker.service docker.socket containerd.service 2>/dev/null || true

# 2. Force-kill any lingering background or zombie worker processes
echo "-> Force-killing lingering background daemons..."
sudo killall -9 dockerd containerd containerd-shim buildkitd 2>/dev/null || true

# 3. Clean out memory-mapped runtime states from the Linux kernel
echo "-> Cleaning temporary in-memory layer mounts..."
sudo rm -rf /run/docker/* /run/containerd/*

# 4. Clean systemd configuration cache
echo "-> Reloading systemd configuration..."
sudo systemctl daemon-reload

# 5. Bring the services back online cleanly
echo "-> Starting services back up..."
sudo systemctl start containerd.service
sudo systemctl start docker.service

echo "=================================================="
echo " Docker is now cleanly restarted with a fresh slate!"
echo "=================================================="
