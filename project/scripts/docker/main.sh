#!/bin/bash

set -euo pipefail

wezterm-mux-server &
echo "[-- ready --]"
exec /usr/sbin/sshd -D
