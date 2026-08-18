#!/bin/bash
set -euo pipefail

. "$(dirname "$0")/bin/init.sh"
bash "$S7ISOL/scripts/new-exec.sh" s7_unset
