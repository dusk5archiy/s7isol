if [[ $0 == "${BASH_SOURCE[0]}" ]]; then
  echo "[-- source --]"
  exit 1
fi

# ------------------------------------------------------------------------------

if [[ -f $S7ISOL/.pre.env ]]; then
  . "$S7ISOL/.pre.env"
else
  . "$S7ISOL/default.pre.env"
fi
