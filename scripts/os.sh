#!/bin/bash
set -euo pipefail

echo "$(. /etc/os-release && echo "$ID")"
