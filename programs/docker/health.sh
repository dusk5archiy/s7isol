#!/bin/bash
set -euo pipefail

echo "The root dir is being set to:"
newgrp docker <<EOF
docker info --format '{{.DockerRootDir}}'
EOF
