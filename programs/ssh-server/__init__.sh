#!/bin/bash
set -euo pipefail

sudo ssh-keygen -A
echo "[-- ready --]"
exec sudo /usr/sbin/sshd -D
