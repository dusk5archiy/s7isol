Dir=$(dirname "${BASH_SOURCE[0]}")
BaseName=$(basename "$Dir")
VirtualEnv=$HOME/venv/$BaseName
# shellcheck disable=SC1091
if [[ -f $VirtualEnv/bin/activate ]]; then
  . "$VirtualEnv/bin/activate"
fi
