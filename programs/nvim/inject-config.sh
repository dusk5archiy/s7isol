Main() {
  local Dir && Dir=$(dirname "${BASH_SOURCE[0]}")
  . "$Dir/env.sh"

  local modules=(
    init
    lua/config/autocmds
    lua/config/keymaps
    lua/config/options
    lua/plugins/plugins
  )
  for module in "${modules[@]}"; do
    local SourceFile="$S7ISOL_NVIM_CONFIG_DIR/$module.lua"
    local DestFile="$NVIM_CONFIG_DIR/$module.lua"
    cat <<EOF >"$DestFile"
return dofile("$SourceFile")
EOF
  done
}

Main
echo "[-- done --] ${BASH_SOURCE[0]}"
