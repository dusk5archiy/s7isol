#!/bin/bash

set -euo pipefail

PATH="$HOME/bin:$PATH"

mkdir -p "$HOME/sockets"
skj wezterm/install
skj nvim/install
