#!/bin/bash

set -euo pipefail

bash cmd/docker/cli.sh npx @devcontainers/cli up --workspace-folder .
bash cmd/docker/cli.sh npx @devcontainers/cli exec --workspace-folder . /bin/bash
