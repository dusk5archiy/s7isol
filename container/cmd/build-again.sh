#!/bin/bash

set -euo pipefail

tag="${1:-}"

sudo docker compose -f compose.$tag.yaml build --no-cache
