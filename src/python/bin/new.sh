#!/bin/bash

# --- Create Python virtual environments

# Params (
TASK_NAME="$1"
# )

mkdir -p .venv

CREATE_VENV_FILE="environments${TASK_NAME:+/$TASK_NAME}/new.sh"

# Execute the task's setup file
if [[ -f "$CREATE_VENV_FILE" ]]; then
  bash "$CREATE_VENV_FILE" "$TASK_NAME"
else
  python -m venv ".venv${TASK_NAME:+/$TASK_NAME}"
fi

# Activate the venv
source bin/env.sh "$TASK_NAME"

# Install dependencies
if [[ -z "$TASK_NAME" && -f "requirements.txt" ]]; then
  pip install -r requirements.txt
else
  REQUIREMENTS_TXT_FILE="environments${TASK_NAME:+/$TASK_NAME}/requirements.txt"

  if [[ -f "$REQUIREMENTS_TXT_FILE" ]]; then
    pip install -r "$REQUIREMENTS_TXT_FILE"
  fi
fi
