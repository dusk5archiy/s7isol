#!/bin/bash
set -euo pipefail

. docker/env.sh
docker exec -it "${CONFIG_PROJECT_NAME}-app-1" /bin/bash -l
