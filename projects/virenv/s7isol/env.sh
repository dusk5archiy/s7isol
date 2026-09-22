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
  local PseudoProjectFolder=$HOME/virenv/${BaseName} # HOME | PWD
  local EnvFolder=$PseudoProjectFolder/.venv
  local ActivateFile=$EnvFolder/bin/activate

  if [[ $SetupMode == 0 ]]; then
    # Env Mode -----------------------------------------------------------------
    if [[ -f $ActivateFile ]]; then
      # shellcheck source=/dev/null
      . "$EnvFolder/bin/activate"
      echo "[-- success --] virenv activated"
    else
      echo "[-- error --] $ActivateFile not found"
      return 1
    fi
  else
    # Setup Mode ---------------------------------------------------------------
    PATH="$HOME/.local/bin:$PATH"

    export UV_PROJECT_ENVIRONMENT=$EnvFolder

    mkdir -p "$PseudoProjectFolder"

    if local PyProjectTomlFile=$PseudoProjectFolder/pyproject.toml && [[ ! -f $PyProjectTomlFile ]]; then
      cp "$Dir/pyproject.toml" "$PyProjectTomlFile"
    fi

    uv venv --allow-existing "$UV_PROJECT_ENVIRONMENT"
    uv sync --project "$PseudoProjectFolder"
  fi
}

Main "$@"

echo "[-- done --] ${BASH_SOURCE[0]}"
