#!/bin/bash

# --- Enter an existing virtual environment

VENV=".venv${1:+/$1}"
source "$VENV/bin/activate"
ENV_FILE="environments${1:+/$1}/env.sh"
if [[ -f "$ENV_FILE" ]]; then
  source "$ENV_FILE"
fi
