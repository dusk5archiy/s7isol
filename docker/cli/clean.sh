#!/bin/bash
set -euo pipefail

. docker/env.sh
docker compose down -v --rmi all
