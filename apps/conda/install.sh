#!/bin/bash
set -euo pipefail

Download=/tmp/Miniconda3-latest-Linux-x86_64.sh

if [[ ! -f $Download ]]; then
  curl -o "$Download" https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
fi
bash "$Download" -b -u -p "$HOME/.data.miniconda3"
