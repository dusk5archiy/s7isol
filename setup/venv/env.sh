VIRTUAL_ENV="$HOME/venv"
if [[ -f "$VIRTUAL_ENV/bin/activate" ]]; then
  # shellcheck disable=SC1091
  . "$VIRTUAL_ENV/bin/activate"
fi
