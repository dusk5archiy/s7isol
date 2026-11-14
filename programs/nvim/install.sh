Main() {
  local Dir && Dir=$(dirname "${BASH_SOURCE[0]}")

  bash "$Dir/install-core.sh"
  bash "$Dir/install-lazy.sh"
  bash "$Dir/inject-config.sh"
  bash "$Dir/dump.sh"

  nvim --headless "+Lazy! sync" +qa

}
Main
echo "[-- done --] ${BASH_SOURCE[0]}"
