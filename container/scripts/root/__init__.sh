#!/bin/bash

set -euo pipefail

awk -F: '$3 >= 1000 && $3 < 60000 {print $1}' /etc/passwd | xargs -r -n1 userdel -r 2>/dev/null || true
bash /tmp/scripts/root/packages.sh
bash /tmp/scripts/root/user.sh
