#!/bin/bash
set -euo pipefail

PATH="$HOME/.local/bin:$PATH"

DIR=$(dirname "${BASH_SOURCE[0]}")

export VIRTUAL_ENV="$HOME/venv"
uv venv "$VIRTUAL_ENV"
uv pip install -r "$DIR/requirements.txt"
