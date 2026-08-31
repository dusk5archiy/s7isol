#!/bin/bash
set -euo pipefail

SshDir=$HOME/.ssh
PrivateKey="$SshDir/id_ed25519"
ssh -o IdentitiesOnly=yes -i "$PrivateKey" git@github.com

echo "[-- done --] ${BASH_SOURCE[0]}"
