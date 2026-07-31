#!/bin/bash

set -euo pipefail

bash ./scripts/docker-root/packages.sh
bash ./scripts/docker-root/user.sh
