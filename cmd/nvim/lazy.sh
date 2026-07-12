#!/bin/bash

set -e

# ------------------------------------------------------------------------------

mkdir -p "$NVIM_CONFIG_DIR"
mkdir -p "$S7ISOL_NVIM_CONFIG_DIR"

# ------------------------------------------------------------------------------

rm -rf $NVIM_CONFIG_DIR
git clone https://github.com/LazyVim/starter $NVIM_CONFIG_DIR
rm -rf $NVIM_CONFIG_DIR/.git

# ------------------------------------------------------------------------------
