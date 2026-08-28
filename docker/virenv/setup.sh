#!/bin/bash
set -euo pipefail

PATH=$HOME/.local/bin:$PATH

export UV_PROJECT_ENVIRONMENT=$HOME/venv
uv venv --allow-existing "$UV_PROJECT_ENVIRONMENT"
uv pip install -r "$(dirname "${BASH_SOURCE[0]}")/requirements.txt"
