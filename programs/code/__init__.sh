#!/bin/bash
set -euo pipefail

Dir=$(dirname "${BASH_SOURCE[0]}")
. "$Dir/env.sh"
UserDataDir=$S7ISOL_VSCODE_USER_DATA_DIR
ExtensionsDir=$S7ISOL_VSCODE_EXTENSIONS_DIR
s7_unset

code \
  ${UserDataDir:+--user-data-dir $UserDataDir} \
  ${ExtensionsDir:+--extensions-dir $ExtensionsDir} \
  "$@"
