#!/bin/bash
set -euo pipefail

PATH="$HOME/bin:$HOME/.local/bin:$PATH"

skj python/install
skj uv/install
skj install make
