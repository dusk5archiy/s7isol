s7_unset
if command -v brave &>/dev/null; then
  brave "$@"
else
  brave-browser "$@"
fi
