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
  # shellcheck disable=SC2034
  local BaseName && BaseName=$(basename "$Dir")

  local PseudoProjectFolder=
  # shellcheck source=/dev/null
  . "$Dir/location.env"

  # ----------------------------------------------------------------------------
  if [[ -z "$PseudoProjectFolder" ]]; then
    echo "[-- error --] Please set PseudoProjectFolder in location.env" >&2 && return 1
  fi

  local EnvFolder=$PseudoProjectFolder/.venv
  local ActivateFile=$EnvFolder/bin/activate

  # ----------------------------------------------------------------------------
  if [[ $SetupMode == 0 ]]; then
    if [[ -f $ActivateFile ]]; then
      # shellcheck source=/dev/null
      . "$EnvFolder/bin/activate" && echo "[-- success --] virenv activated"
    else
      echo "[-- error --] $ActivateFile not found" >&2 && return 1
    fi
  fi

  # ----------------------------------------------------------------------------
  if [[ $SetupMode == 1 ]]; then
    PATH="$HOME/.local/bin:$PATH"

    export UV_PROJECT_ENVIRONMENT=$EnvFolder

    mkdir -p "$PseudoProjectFolder"

    if local PyProjectTomlFile=$PseudoProjectFolder/pyproject.toml &&
      [[ ! -f $PyProjectTomlFile ]]; then cp "$Dir/pyproject.toml" "$PyProjectTomlFile"; fi

    uv venv --allow-existing "$UV_PROJECT_ENVIRONMENT"
    uv sync --project "$PseudoProjectFolder"
  fi
}

Main "$@"
