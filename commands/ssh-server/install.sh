#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo "$ID") in
ubuntu)
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends openssh-server

  sudo mkdir -p /var/run/sshd
  sudo tee -a /etc/ssh/sshd_config <<EOF
PasswordAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

AcceptEnv *
EOF
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
