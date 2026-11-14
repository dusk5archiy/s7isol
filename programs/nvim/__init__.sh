Main() {
  # shellcheck disable=SC1091
  if [[ -f cmd/env.sh ]]; then
    . cmd/env.sh
  fi

  local Dir && Dir=$(dirname "${BASH_SOURCE[0]}")
  . "$Dir/env.sh"
  s7_unset

  nvim "$@"
}

Main
