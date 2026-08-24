#!/bin/bash
set -euo pipefail

if [[ -f $S7ISOL/.claude.env ]]; then
  . "$S7ISOL/.claude.env"
fi
s7_unset
claude
