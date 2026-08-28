#!/bin/bash
set -euo pipefail

User=$(whoami)
sudo groupadd docker || true
sudo usermod -aG docker "$User"
