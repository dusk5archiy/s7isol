# shellcheck source=/dev/null

Main() {
  local SetupMode=0

  local Arg=
  while [[ $# -gt 0 ]]; do
    Arg=$1
    case $Arg in
    --setup)
      SetupMode=1
      ;;
    esac
    shift
  done

  # ----------------------------------------------------------------------------
  local Dir && Dir=$(dirname "${BASH_SOURCE[0]}")
  local BaseName && BaseName=$(basename "$Dir")
  local PseudoProjectFolder=$HOME/virenv/${BaseName}
  local EnvFolder=$PseudoProjectFolder/.venv

  if [[ $SetupMode == 0 ]]; then
    # Env Mode -----------------------------------------------------------------
    if [[ -f $EnvFolder/bin/activate ]]; then
      . "$EnvFolder/bin/activate"
      echo "[-- success --] virenv activated"
    fi
  else
    # Setup Mode ---------------------------------------------------------------

    PATH="$HOME/bin:$HOME/.local/bin:$PATH"

    export UV_PROJECT_ENVIRONMENT=$EnvFolder

    mkdir -p "$PseudoProjectFolder"

    cp "$Dir/pyproject.toml" "$PseudoProjectFolder/pyproject.toml"

    uv venv --allow-existing "$UV_PROJECT_ENVIRONMENT"
    uv sync --project "$PseudoProjectFolder"
  fi
}

Main "$@"

echo "[-- done --] ${BASH_SOURCE[0]}"
