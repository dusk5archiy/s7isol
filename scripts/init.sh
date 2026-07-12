#!/bin/bash

# ------------------------------------------------------------------------------

S7ISOL_EXECUTABLE="$HOME/bin/skj"

# ------------------------------------------------------------------------------

/usr/bin/mkdir -p "$HOME/bin"
/usr/bin/cat "$S7ISOL/bin/skj.sh" >"$S7ISOL_EXECUTABLE"
sed -i "s@<|S7ISOL|>@$S7ISOL@g" "$S7ISOL_EXECUTABLE"

# ------------------------------------------------------------------------------

{
  env | grep '^S7ISOL_' | while IFS='=' read -r name value; do
    echo "export $name=\"$value\""
  done
} >/tmp/replacement.txt

sed -i -e "/S7ISOL_PRE_ENV/r /tmp/replacement.txt" -e "s@S7ISOL_PRE_ENV@@g" "$S7ISOL_EXECUTABLE"

# ------------------------------------------------------------------------------

/usr/bin/chmod +x "$S7ISOL_EXECUTABLE"
