Main() {
  local Dir && Dir=$(dirname "${BASH_SOURCE[0]}")

  . "$Dir/env.sh"
  mkdir -p "$NVIM_CONFIG_DIR"
  cp "$S7ISOL_NVIM_CONFIG_DIR/lazyvim.json" "$NVIM_CONFIG_DIR/lazyvim.json"
}

Main
echo "[-- done --] ${BASH_SOURCE[0]}"
