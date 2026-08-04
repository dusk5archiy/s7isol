#!/bin/bash

set -euo pipefail

bash cmd/devcontainer/cli.sh npx @devcontainers/cli up --workspace-folder .
bash cmd/devcontainer/cli.sh npx @devcontainers/cli exec /bin/bash --workspace-folder .
