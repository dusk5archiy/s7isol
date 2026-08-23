#!/bin/bash
set -euo pipefail

mkdir -p "$CONFIG_WORKSPACE"
mkdir -p "$CONFIG_XDG_RUNTIME_DIR"
chmod 2700 "$CONFIG_XDG_RUNTIME_DIR"
