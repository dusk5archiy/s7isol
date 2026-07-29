#!/bin/bash

DOWNLOAD="/tmp/Miniconda3-latest-Linux-x86_64.sh"

if [[ ! -f "$DOWNLOAD" ]]; then
  curl -o "$DOWNLOAD" https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
fi
bash "$DOWNLOAD" -b -u -p "$HOME/.data.miniconda3"
