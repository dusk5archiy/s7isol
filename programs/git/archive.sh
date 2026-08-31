#!/bin/bash
set -euo pipefail

git archive --format=zip --output="../z-$(basename "$PWD").zip" HEAD

echo "[-- done --] ${BASH_SOURCE[0]}"
