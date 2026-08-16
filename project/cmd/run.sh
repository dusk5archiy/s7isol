#!/bin/bash
set -euo pipefail

. setup/venv/main/env.sh
python -B main.py demo
