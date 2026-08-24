S7ISOL=$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")
export SHELL=${SHELL:-/bin/bash}

function s7_unset() {
  unset "$(printenv | awk -F= '/^S7ISOL/ {print $1}')"
  unset -f s7_unset
  set +euo pipefail
  return 0
}

export S7ISOL
export -f s7_unset
