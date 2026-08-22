#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------

CONFIG_DIR="$XDG_CONFIG_HOME/xournalpp"

SETTINGS_FILE="$S7ISOL/config/xournal/settings.xml"
TEMPLATE_FILE="$S7ISOL/config/xournal/template.typ"
COLOR_PALETTE_FILE="$S7ISOL/config/xournal/palette.gpl"

# ------------------------------------------------------------------------------

TOOLBAR_INI_FILE="$S7ISOL/config/xournal/toolbar.ini"

RELEASE_ID="$(. /etc/os-release && echo "$ID")"

case "$RELEASE_ID" in
msys2)
  TOOLBAR_DESTINATION="/ucrt64/share/xournalpp/ui/toolbar.ini"
  ;;
*)
  TOOLBAR_DESTINATION="/usr/share/xournalpp/ui/toolbar.ini"
  ;;
esac

sudo cp "$TOOLBAR_INI_FILE" "$TOOLBAR_DESTINATION"

# ------------------------------------------------------------------------------

case "$RELEASE_ID" in
msys2)
  TEMPLATE_FILE="$(cygpath -w "$TEMPLATE_FILE" | sed 's/\\/\\\\/g')"
  COLOR_PALETTE_FILE="$(cygpath -w "$COLOR_PALETTE_FILE" | sed 's/\\/\\\\/g')"
  EDITOR_COMMAND="'$(cygpath -w "$(which nvim-qt)" | sed 's/\\/\\\\/g')'"
  ;;
*)
  EDITOR_COMMAND="'skj nvim-qt'"
  ;;
esac

# ------------------------------------------------------------------------------

cat "$SETTINGS_FILE" >"$CONFIG_DIR/settings.xml"

sed -i "s@<|DEFAULT_TEMPLATE_HERE|>@$TEMPLATE_FILE@g" "$CONFIG_DIR/settings.xml"
sed -i "s@<|COLOR_PALETTE_HERE|>@$COLOR_PALETTE_FILE@g" "$CONFIG_DIR/settings.xml"
sed -i "s@<|EDITOR_COMMAND_HERE|>@$EDITOR_COMMAND@g" "$CONFIG_DIR/settings.xml"

# ------------------------------------------------------------------------------

echo "[-- S7ISOL --] Done."
