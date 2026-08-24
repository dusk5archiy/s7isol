#!/bin/bash
set -euo pipefail

_download=/tmp/Miniconda3-latest-Linux-x86_64.sh

if [[ ! -f $_download ]]; then
  curl -o "$_download" https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
fi
bash "$_download" -b -u -p "$HOME/.data.miniconda3"
