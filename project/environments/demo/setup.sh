#!/bin/bash

set -euo pipefail

ENV_NAME="$(basename "$(dirname "${BASH_SOURCE[0]}")")"

mkdir -p ".venv"
python -m venv ".venv/$ENV_NAME"

source ".venv/$ENV_NAME/bin/activate"
pip install -r "environments/$ENV_NAME/requirements.txt"
