#!/bin/bash

# ------------------------------------------------------------------------------

code \
  ${OLD_VSCODE_USER_DATA_DIR:+--user-data-dir "$OLD_VSCODE_USER_DATA_DIR"} \
  ${OLD_VSCODE_EXTENSIONS_DIR:+--extensions-dir "$OLD_VSCODE_EXTENSIONS_DIR"} \
  "${@:2}"
