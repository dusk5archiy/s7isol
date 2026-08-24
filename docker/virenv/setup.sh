#!/bin/bash
set -euo pipefail

PATH=$HOME/.local/bin:$PATH

export VIRTUAL_ENV=$HOME/venv
uv venv "$VIRTUAL_ENV"
uv pip install -r "$(dirname "${BASH_SOURCE[0]}")/requirements.txt"
