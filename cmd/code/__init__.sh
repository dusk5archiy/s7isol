#!/bin/bash

# ------------------------------------------------------------------------------

if [[ -f "$S7ISOL/.claude.env" ]]; then
  source "$S7ISOL/.claude.env"
fi

# ------------------------------------------------------------------------------

. "$S7ISOL/cmd/code/env.sh"
user_data_dir="$S7ISOL_VSCODE_USER_DATA_DIR"
extensions_dir="$S7ISOL_VSCODE_EXTENSIONS_DIR"

s7_unset

code \
  ${user_data_dir:+--user-data-dir "$user_data_dir"} \
  ${extensions_dir:+--extensions-dir "$extensions_dir"} \
  "${@}"
