#!/bin/bash

set -euo pipefail

bash ./scripts/docker-user/s7isol.sh
PATH="$HOME/bin:$PATH"
skj wezterm/install
