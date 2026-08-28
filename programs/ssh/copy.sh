#!/bin/bash
set -euo pipefail

Source=$1

if [[ -z $Source ]]; then
  echo "[-- invalid argument --]" >&2
  exit 1
fi

echo "Source: $Source"

PrivateKey=$Source/id_ed25519
PublicKey=$Source/id_ed25519.pub

if [[ ! -f $PublicKey || ! -f $PrivateKey ]]; then
  echo "[-- No public or private key exists. --]"
  exit 0
fi

Destination=$HOME/.ssh
mkdir -p "$Destination"
cp "$PrivateKey" "$PublicKey" "$Destination"

ls -al "$Destination"

echo "[-- Done --] ${BASH_SOURCE[0]}"
