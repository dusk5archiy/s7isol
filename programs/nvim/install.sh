#!/bin/bash
set -euo pipefail

_dir=$(dirname "${BASH_SOURCE[0]}")

bash "$_dir/install-core.sh"
bash "$_dir/lazy.sh"
bash "$_dir/init.sh"
bash "$_dir/dump.sh"

nvim --headless "+Lazy! sync" +qa
