#!/bin/bash
set -euo pipefail

useradd -m -s /bin/bash adevuser
echo "adevuser:adevuser" | chpasswd
chown -R adevuser:adevuser /home/adevuser
echo "adevuser ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/adevuser
