if [[ "$0" == "$BASH_SOURCE" ]]; then
  echo "[-- source --]"
  exit 1
fi

# ------------------------------------------------------------------------------

if [[ -f "$S7ISOL/.post.env" ]]; then
  source "$S7ISOL/.post.env"
else
  source "$S7ISOL/default.post.env"
fi

# ------------------------------------------------------------------------------
