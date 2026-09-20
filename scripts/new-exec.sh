Main() {
  local S7isolExecutable=/usr/local/bin/skj

  # ------------------------------------------------------------------------------
  cat "$S7ISOL/bin/skj.sh" | sudo tee $S7isolExecutable >/dev/null
  sudo sed -i "s@<|S7ISOL|>@$S7ISOL@g" $S7isolExecutable

  # ------------------------------------------------------------------------------
  env | awk -F= '/^S7ISOL_/ {print "export " $1 "=\"" $2 "\""}' >/tmp/replacement.txt
  sudo sed -i -e "/S7ISOL_PRE_ENV/r /tmp/replacement.txt" -e "s@S7ISOL_PRE_ENV@@g" "$S7isolExecutable"

  # ------------------------------------------------------------------------------

  sudo chmod +x "$S7isolExecutable"
}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
