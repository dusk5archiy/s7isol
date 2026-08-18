#!/bin/bash
set -euo pipefail

DIR="$(dirname "${BASH_SOURCE[0]}")"
ENV_NAME="$(basename "$DIR")"

PATH="$HOME/.local/bin:$PATH"

ENV_DIR="$HOME/venv/$ENV_NAME"
uv venv "$ENV_DIR"
uv pip install --python "$ENV_DIR/bin/python" -r "$DIR/requirements.txt"
