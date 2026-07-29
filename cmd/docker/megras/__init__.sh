#!/bin/bash

CONFIG_MEGRAS_DIR="$HOME/.data.megras-config"
DATA_MEGRAS_DIR="$HOME/.data.megras-data"
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

$S7ISOL_SUDO docker stop megras
$S7ISOL_SUDO docker rm megras

$S7ISOL_SUDO docker run -d -it \
  --name megras \
  -p 8080:8080 \
  -v "$CONFIG_MEGRAS_DIR/config.json":/config.json \
  -v "$DATA_MEGRAS_DIR":/data \
  -v "$CONFIG_MEGRAS_DIR/assets":/assets \
  floruosch/megras:latest
