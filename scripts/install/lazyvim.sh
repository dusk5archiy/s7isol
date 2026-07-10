#!/bin/bash

# ------------------------------------------------------------------------------

mkdir -p "$NVIM_CONFIG_DIR"
mkdir -p "$S7ISOL_NVIM_CONFIG_DIR"

# ------------------------------------------------------------------------------

rm -rf $NVIM_CONFIG_DIR/*
git clone https://github.com/LazyVim/starter $NVIM_CONFIG_DIR
rm -rf $NVIM_CONFIG_DIR/.git

# ------------------------------------------------------------------------------

echo 'dofile(string.format("%s/init.lua", os.getenv("S7ISOL_NVIM_CONFIG_DIR")))' >$NVIM_CONFIG_DIR/init.lua
echo 'return dofile(string.format("%s/lua/config/autocmd.lua", os.getenv("S7ISOL_NVIM_CONFIG_DIR")))' >$NVIM_CONFIG_DIR/lua/config/autocmd.lua
echo 'return dofile(string.format("%s/lua/config/keymaps.lua", os.getenv("S7ISOL_NVIM_CONFIG_DIR")))' >$NVIM_CONFIG_DIR/lua/config/keymaps.lua
echo 'return dofile(string.format("%s/lua/config/options.lua", os.getenv("S7ISOL_NVIM_CONFIG_DIR")))' >$NVIM_CONFIG_DIR/lua/config/options.lua
echo 'return dofile(string.format("%s/lua/plugins/plugins.lua", os.getenv("S7ISOL_NVIM_CONFIG_DIR")))' >$NVIM_CONFIG_DIR/lua/plugins/plugins.lua
