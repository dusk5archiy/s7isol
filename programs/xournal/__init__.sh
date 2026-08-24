#!/bin/bash
set -euo pipefail

s7_unset
xournalpp "$@" >/dev/null 2>&1 &
disown
