#!/bin/bash
set -euo pipefail

if command -v reboot &>/dev/null; then
  reboot
fi
