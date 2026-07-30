export S7ISOL="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"

if ! command -v sudo &>/dev/null; then
  sudo() { "$@"; }
fi

function s7_unset() {
  unset -f sudo
  unset $(printenv | awk -F= '/^S7ISOL/ {print $1}')
  unset -f s7_unset
  return 0
}

export -f s7_unset
