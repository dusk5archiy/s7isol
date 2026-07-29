#!/usr/bin/env bash

set -e

FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
FONT_DIR="$HOME/.fonts"
TEMP_DIR=$(mktemp -d)

# Ensure required utilities are installed
for cmd in curl unzip fc-cache; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: '$cmd' is required but not installed." >&2
    exit 1
  fi
done

echo "Creating font directory at $FONT_DIR..."
mkdir -p "$FONT_DIR"

echo "Downloading JetBrainsMono Nerd Font..."
if [[ ! -f "$TEMP_DIR/JetBrainsMono.zip" ]]; then
  curl -fLo "$TEMP_DIR/JetBrainsMono.zip" "$FONT_URL"
fi

echo "Extracting font files into $FONT_DIR..."
unzip -o "$TEMP_DIR/JetBrainsMono.zip" -d "$FONT_DIR"

echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo "Updating system font cache..."
fc-cache -fv "$FONT_DIR"

echo "Done! JetBrainsMono Nerd Font has been installed successfully."
