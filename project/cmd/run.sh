#!/bin/bash

set -euo pipefail

source setup/venv/main/env.sh
python -B main.py demo
