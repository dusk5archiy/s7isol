#!/bin/bash
set -euo pipefail

PATH="$HOME/bin:$PATH"
skj update

skj python/install
skj bazel/install

skj install make gcc
