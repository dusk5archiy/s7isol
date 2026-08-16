#!/bin/bash
set -euo pipefail

sudo docker system prune -a -f --volumes
sudo docker image prune -a -f
