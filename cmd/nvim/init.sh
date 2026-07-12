#!/bin/bash

# ------------------------------------------------------------------------------

cat <<'EOF' | tee "$NVIM_CONFIG_DIR/init.lua"
local S7ISOL_NVIM_CONFIG_DIR = os.getenv("S7ISOL_NVIM_CONFIG_DIR")

if S7ISOL_NVIM_CONFIG_DIR == nil then
	return
end

dofile(string.format("%s/init.lua", S7ISOL_NVIM_CONFIG_DIR))
EOF

echo 'return dofile(string.format("%s/lua/config/autocmd.lua", os.getenv("S7ISOL_NVIM_CONFIG_DIR")))' >$NVIM_CONFIG_DIR/lua/config/autocmd.lua
echo 'return dofile(string.format("%s/lua/config/keymaps.lua", os.getenv("S7ISOL_NVIM_CONFIG_DIR")))' >$NVIM_CONFIG_DIR/lua/config/keymaps.lua
echo 'return dofile(string.format("%s/lua/config/options.lua", os.getenv("S7ISOL_NVIM_CONFIG_DIR")))' >$NVIM_CONFIG_DIR/lua/config/options.lua
echo 'return dofile(string.format("%s/lua/plugins/plugins.lua", os.getenv("S7ISOL_NVIM_CONFIG_DIR")))' >$NVIM_CONFIG_DIR/lua/plugins/plugins.lua

# ------------------------------------------------------------------------------

python "$S7ISOL/src/nvim/utils/lazyvim_dump.py"

# ------------------------------------------------------------------------------

echo "[-- S7ISOL --] Done"
