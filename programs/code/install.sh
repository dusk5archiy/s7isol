#!/bin/bash
set -euo pipefail

Dir=$(dirname "${BASH_SOURCE[0]}")

bash "$Dir/install-core.sh"
bash "$Dir/extensions.sh"
bash "$Dir/dump.sh"
