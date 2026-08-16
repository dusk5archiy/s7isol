#!/bin/bash
set -euo pipefail

sudo docker compose -f compose.base.yaml build --no-cache
