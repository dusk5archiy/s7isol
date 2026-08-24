#!/bin/bash
set -euo pipefail

PORT=${1:-}
curl -I "http://localhost:$PORT"
