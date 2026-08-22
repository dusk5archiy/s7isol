#!/bin/bash
set -euo pipefail

. "$S7ISOL/commands/nvim/env.sh"

modules=(
  "init"
  "lua/config/autocmd"
  "lua/config/keymaps"
  "lua/config/options"
  "lua/plugins/plugins"
)
for module in "${modules[@]}"; do
  cat <<EOF >"$NVIM_CONFIG_DIR/$module.lua"
return dofile("$S7ISOL_NVIM_CONFIG_DIR/$module.lua")
EOF
done
