if [[ $0 == "${BASH_SOURCE[0]}" ]]; then
  echo "[-- source --]"
  exit 0
fi
cd "$S7ISOL" || return
