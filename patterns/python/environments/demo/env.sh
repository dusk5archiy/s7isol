if [[ "$0" == "$BASH_SOURCE" ]]; then
  echo "[-- source --]"
  exit 1
fi

ENV_NAME="$(basename "$(dirname "${BASH_SOURCE[0]}")")"
source ".venv/$ENV_NAME/bin/activate"
