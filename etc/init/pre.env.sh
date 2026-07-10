#!/bin/bash

# ------------------------------------------------------------------------------

if [[ "$0" == "$BASH_SOURCE" ]]; then
  exit 1
fi

# ------------------------------------------------------------------------------

if [[ -f "$S7ISOL/.pre.env" ]]; then
  source "$S7ISOL/.pre.env"
else
  source "$S7ISOL/default.pre.env"
fi
