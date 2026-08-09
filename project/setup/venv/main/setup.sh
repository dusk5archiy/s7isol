#!/bin/bash

set -euo pipefail

DIR="$(dirname "${BASH_SOURCE[0]}")"
ENV_NAME="$(basename "$DIR")"

PATH="$HOME/.local/bin:$PATH"

uv venv "$HOME/venv/$ENV_NAME"
uv pip compile "$DIR/requirements.txt" -o /tmp/requirements.txt
uv pip sync \
  --python "$HOME/venv/$ENV_NAME/bin/python" /tmp/requirements.txt

rm -f /tmp/requirements.txt
