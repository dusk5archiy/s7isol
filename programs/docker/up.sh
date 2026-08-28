#!/bin/bash
set -euo pipefail

sudo systemctl start docker
echo "[-- done --] ${BASH_SOURCE[0]}"
