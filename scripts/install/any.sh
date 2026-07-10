#!/bin/bash

# ------------------------------------------------------------------------------

packages=("$@")

if [[ ${#packages[@]} -eq 0 ]]; then
  return 1
fi

# ------------------------------------------------------------------------------

sudo apt install --no-install-recommends --no-install-suggests "${packages[@]}"
