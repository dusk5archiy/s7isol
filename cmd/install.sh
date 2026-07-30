#!/usr/bin/env bash

# ------------------------------------------------------------------------------

packages=("$@")

if [[ ${#packages[@]} -eq 0 ]]; then
  return 1
fi

# ------------------------------------------------------------------------------

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  sudo apt-get install -y \
    --no-install-recommends \
    "${packages[@]}"
  ;;
esac
