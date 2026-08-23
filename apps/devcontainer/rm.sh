#!/bin/bash
set -euo pipefail

sudo docker rm -f "$(sudo docker ps -a -q --filter label=devcontainer.local_folder="$(pwd)")"
