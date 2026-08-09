#!/bin/bash

set -euo pipefail

ENV_NAME="$(basename "$(dirname "${BASH_SOURCE[0]}")")"

PATH="$HOME/.local/bin:$PATH"

uv venv "$HOME/venv/$ENV_NAME"
uv pip compile "scripts/envs/$ENV_NAME/requirements.txt" -o "tmp/requirements.txt"
uv pip sync \
  --python "$HOME/venv/$ENV_NAME/bin/python" \
  "tmp/requirements.txt"
