#!/bin/bash

if [[ -f "cmd/env.sh" ]]; then
  source "cmd/env.sh"
fi

if [[ -f "$S7ISOL/.claude.env" ]]; then
  source "$S7ISOL/.claude.env"
fi

nvim ${@}
