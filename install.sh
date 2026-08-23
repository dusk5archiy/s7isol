#!/bin/bash
set -euo pipefail

. "$(dirname "$0")/bin/init.sh"
bash "$S7ISOL/scripts/new-exec.sh"
"$HOME/bin/skj" setup/post
"$HOME/bin/skj" setup/profile
