if [[ "$0" == "$BASH_SOURCE" ]]; then
  echo "[-- source --]"
  exit 1
fi

ENV_NAME="$(basename "$(dirname "${BASH_SOURCE[0]}")")"
ENV_FILE=".venv/$ENV_NAME/bin/activate"
if [[ -f "$ENV_FILE" ]]; then
  source "$ENV_FILE"
fi
