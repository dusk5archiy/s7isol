export S7ISOL="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"

# ------------------------------------------------------------------------------

function s7_unset() {
  unset $(printenv | awk -F= '/^S7ISOL/ {print $1}')
  unset -f s7_unset
  return 0
}

export -f s7_unset
