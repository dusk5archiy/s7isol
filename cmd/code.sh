#!/bin/bash

# ------------------------------------------------------------------------------

code \
  ${S7ISOL_VSCODE_USER_DATA_DIR:+--user-data-dir "$S7ISOL_VSCODE_USER_DATA_DIR"} \
  ${S7ISOL_VSCODE_EXTENSIONS_DIR:+--extensions-dir "$S7ISOL_VSCODE_EXTENSIONS_DIR"} \
  "${@}"
