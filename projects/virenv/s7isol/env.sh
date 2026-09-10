#!/bin/bash
# shellcheck source=/dev/null

SetupMode=0

while [[ $# -gt 0 ]]; do
  Arg=$1

  case $Arg in
  --setup)
    SetupMode=1
    ;;
  esac
  shift
done

# ------------------------------------------------------------------------------
Dir=$(dirname "${BASH_SOURCE[0]}")
BaseName=$(basename "$Dir")
PseudoProjectFolder=$HOME/virenv/${BaseName}
EnvFolder=$PseudoProjectFolder/.venv

# Setup Mode -------------------------------------------------------------------
if [[ $SetupMode == 1 ]]; then
  set -euo pipefail

  PATH="$HOME/bin:$HOME/.local/bin:$PATH"

  export UV_PROJECT_ENVIRONMENT=$EnvFolder

  mkdir -p "$PseudoProjectFolder"

  cp "$Dir/pyproject.toml" "$PseudoProjectFolder/pyproject.toml"

  uv venv --allow-existing "$UV_PROJECT_ENVIRONMENT"
  uv sync --project "$PseudoProjectFolder"
  exit 0
fi

# Env Mode ---------------------------------------------------------------------
if [[ -f $EnvFolder/bin/activate ]]; then
  . "$EnvFolder/bin/activate"
  echo "[-- done --] virenv activated"
fi
