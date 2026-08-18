#!/bin/bash
set -euo pipefail

if command -v poweroff &>/dev/null; then
  poweroff
fi
