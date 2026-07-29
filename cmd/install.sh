#!/usr/bin/env bash

# ------------------------------------------------------------------------------

packages=("$@")

if [[ ${#packages[@]} -eq 0 ]]; then
  return 1
fi

# ------------------------------------------------------------------------------

case "$S7ISOL_OS" in
ubuntu)
  $S7ISOL_SUDO apt install \
    --no-install-recommends \
    --no-install-suggests \
    "${packages[@]}"
  ;;
esac
