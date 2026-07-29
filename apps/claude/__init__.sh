#!/usr/bin/env bash

if [[ -f "$S7ISOL/.claude.env" ]]; then
  source "$S7ISOL/.claude.env"
fi
s7_unset
claude
