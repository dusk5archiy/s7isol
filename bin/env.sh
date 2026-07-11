#!/bin/bash

# ------------------------------------------------------------------------------

if [[ "$0" == "$BASH_SOURCE" ]]; then
  exit 1
fi

# ------------------------------------------------------------------------------

export S7ISOL="$(realpath "${BASH_SOURCE[0]}/../..")"
export OS="$(source /etc/os-release && echo $ID)"

case "$OS" in
msys2)
  export S7ISOL_SUDO=""
  ;;
*)
  export S7ISOL_SUDO="sudo"
  ;;
esac
