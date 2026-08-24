#!/bin/bash
set -euo pipefail

_dir=$(dirname "${BASH_SOURCE[0]}")
. "$_dir/env.sh"

if [[ -z ${NVIM_CONFIG_DIR:-} ]]; then
  exit 1
fi

rm -rf "$NVIM_CONFIG_DIR"
git clone https://github.com/LazyVim/starter "$NVIM_CONFIG_DIR" --depth 1
rm -rf "$NVIM_CONFIG_DIR/.git"
