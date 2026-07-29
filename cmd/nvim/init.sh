#!/usr/bin/env bash

set -e

# ------------------------------------------------------------------------------

if [[ -z "$S7ISOL_NVIM_CONFIG_DIR" || -z "$NVIM_CONFIG_DIR" ]]; then
  exit 1
fi

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

# ------------------------------------------------------------------------------

skj nvim/dump

# ------------------------------------------------------------------------------

echo "[-- S7ISOL --] Done"
