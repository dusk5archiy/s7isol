#!/bin/bash
set -euo pipefail

SshDir=$HOME/.ssh
PrivateKey=$SshDir/id_ed25519
PublicKey=$SshDir/id_ed25519.pub

if [[ ! -f $PublicKey || ! -f $PrivateKey ]]; then
  echo "[-- No public or private key exists. --]"
  exit 0
fi

eval "$(ssh-agent -s)"
ssh-add "$PrivateKey"
cat "$PublicKey"
