#!/bin/bash
set -euo pipefail

. docker/env.sh
docker compose -p "${CONFIG_PROJECT_NAME}" down -v
