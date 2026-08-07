#!/bin/bash

set -euo pipefail

awk -F: '$3 >= 1000 && $3 < 60000 {print $1}' /etc/passwd | xargs -r -n1 userdel -r 2>/dev/null || true
useradd -m -s /bin/bash adevuser
echo "adevuser:adevuser" | chpasswd
chown -R adevuser:adevuser /home/adevuser
echo "adevuser ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/adevuser
