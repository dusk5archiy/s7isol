#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------

if [[ ! -f ".pre.env" ]]; then
  cp example.pre.env .pre.env
fi
