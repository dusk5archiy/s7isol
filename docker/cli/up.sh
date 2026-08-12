#!/bin/bash
set -euo pipefail

. docker/env.sh
docker compose up -d $@
