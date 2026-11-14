Main() {
  local Dir && Dir=$(dirname "${BASH_SOURCE[0]}")
  . "$Dir/env.sh"

  : "${NVIM_CONFIG_DIR:?}"
  rm -rf "$NVIM_CONFIG_DIR"
  git clone https://github.com/LazyVim/starter "$NVIM_CONFIG_DIR" --depth 1
  rm -rf "$NVIM_CONFIG_DIR/.git"
}

Main
echo "[-- done --] ${BASH_SOURCE[0]}"
