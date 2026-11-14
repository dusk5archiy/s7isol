Main() {
  Dir=$(dirname "${BASH_SOURCE[0]}")

  bash "$Dir/install-core.sh"
  bash "$Dir/dump.sh"
  bash "$Dir/group.sh"
}

Main
echo "[-- done --] ${BASH_SOURCE[0]}"
