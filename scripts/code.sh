#!/bin/bash

# ------------------------------------------------------------------------------

code \
  ${YOUR_VSCODE_USER_DATA_DIR:+--user-data-dir "$YOUR_VSCODE_USER_DATA_DIR"} \
  ${YOUR_VSCODE_EXTENSIONS_DIR:+--extensions-dir "$YOUR_VSCODE_EXTENSIONS_DIR"} \
  "${@:2}"
