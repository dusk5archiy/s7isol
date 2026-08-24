#!/bin/bash
set -euo pipefail

CONFIG_MEGRAS_DIR=$HOME/.data.megras-config
DATA_MEGRAS_DIR=$HOME/.data.megras-data
rm -rf "$CONFIG_MEGRAS_DIR"
rm -rf "$DATA_MEGRAS_DIR"
mkdir -p "$CONFIG_MEGRAS_DIR"
mkdir -p "$DATA_MEGRAS_DIR"
mkdir -p "$CONFIG_MEGRAS_DIR/assets"

cat <<EOF >"$CONFIG_MEGRAS_DIR/config.json"
{
  "storagePath": "/data",
  "httpPort": 8080
}
EOF

sudo docker stop megras
sudo docker rm megras

sudo docker run -d -it \
  --name megras \
  -p 8080:8080 \
  -v "$CONFIG_MEGRAS_DIR/config.json":/config.json \
  -v "$DATA_MEGRAS_DIR":/data \
  -v "$CONFIG_MEGRAS_DIR/assets":/assets \
  floruosch/megras:latest
