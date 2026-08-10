#!/bin/bash
set -euo pipefail

bash docker/cli.sh docker compose up -d $@
