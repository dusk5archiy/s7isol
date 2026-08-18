#!/bin/bash
set -euo pipefail

. docker/env.sh

xhost +local:
# docker exec -it "${CONFIG_PROJECT_NAME}-app-1" /bin/bash -l
docker exec -i "${CONFIG_PROJECT_NAME}-app-1" /bin/bash -lc "make wezterm"
