#!/bin/bash

set -euo pipefail

sudo docker compose build
ssh-keygen -R "[localhost]:2222"
