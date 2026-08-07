#!/bin/bash

set -euo pipefail

ENV_NAME="$(basename "$(dirname "${BASH_SOURCE[0]}")")"

uv venv ".venv/$ENV_NAME"
uv pip install \
  --python ".venv/$ENV_NAME/bin/python" \
  -r "environments/$ENV_NAME/requirements.txt"
