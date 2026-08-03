#!/bin/bash

set -euo pipefail

# ------------------------------------------------------------------------------

S7ISOL_EXECUTABLE="$HOME/bin/skj"

# ------------------------------------------------------------------------------

mkdir -p "$HOME/bin"
cat "$S7ISOL/bin/skj.sh" >"$S7ISOL_EXECUTABLE"
sed -i "s@<|S7ISOL|>@$S7ISOL@g" "$S7ISOL_EXECUTABLE"

# ------------------------------------------------------------------------------

env | awk -F= '/^S7ISOL_/ {print "export " $1 "=\"" $2 "\""}' >/tmp/replacement.txt
sed -i -e "/S7ISOL_PRE_ENV/r /tmp/replacement.txt" -e "s@S7ISOL_PRE_ENV@@g" "$S7ISOL_EXECUTABLE"

# ------------------------------------------------------------------------------

chmod +x "$S7ISOL_EXECUTABLE"
