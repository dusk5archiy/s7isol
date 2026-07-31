#!/bin/bash

set -euo pipefail

sudo WEZTERM_UNIX_SOCKET="$WEZTERM_UNIX_SOCKET" docker compose build
ssh-keygen -R "[127.0.0.1]:2222"
