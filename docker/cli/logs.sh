#!/bin/bash
set -euo pipefail

. docker/env.sh
docker logs "${CONFIG_PROJECT_NAME}-app-1" | less
