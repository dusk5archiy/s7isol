#!/bin/bash
set -euo pipefail

if command -v bazel &>/dev/null; then
  exit 0
fi

sudo curl -fsSL https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64 -o /usr/local/bin/bazel
sudo chmod +x /usr/local/bin/bazel
