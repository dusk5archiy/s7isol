#!/bin/bash
set -euo pipefail

source docker/env.sh
sudo docker exec -it "${CONFIG_PROJECT_NAME}-app-1" /bin/bash --login
