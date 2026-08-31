#!/bin/bash
set -euo pipefail

PATH=$HOME/bin:$PATH
skj sync

skj python/install
skj bazel/install

skj install make gcc
