#!/bin/bash

# scripts/docker-root/__init__.sh

set -euo pipefail

bash ./scripts/docker-root/packages.sh
bash ./scripts/docker-root/user.sh
bash ./scripts/docker-root/ssh.sh
