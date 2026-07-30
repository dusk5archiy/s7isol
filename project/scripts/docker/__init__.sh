#!/bin/bash

set -euo pipefail

bash ./scripts/docker/packages.sh
bash ./scripts/docker/user.sh
bash ./scripts/docker/ssh.sh
bash ./scripts/docker/s7isol.sh
PATH="/home/asdfjkl/bin:$PATH"
skj wezterm/install
