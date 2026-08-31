#!/bin/bash
set -euo pipefail

PATH=$HOME/bin:$HOME/.local/bin:$PATH

skj sync
skj python/install
skj uv/install
skj install make

Dir=$(dirname "${BASH_SOURCE[0]}")
BaseName=$(basename "$Dir")

export UV_PROJECT_ENVIRONMENT=$HOME/venv/$BaseName
PseudoProjectFolder=$HOME/virenv/$BaseName

mkdir -p "$PseudoProjectFolder"

cp "$Dir/pyproject.toml" "$PseudoProjectFolder/pyproject.toml"

uv venv --allow-existing "$UV_PROJECT_ENVIRONMENT"
uv sync --project "$PseudoProjectFolder"
