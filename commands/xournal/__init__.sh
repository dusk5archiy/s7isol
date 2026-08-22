#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------

xournalpp ${@} >/dev/null 2>&1 &
disown
