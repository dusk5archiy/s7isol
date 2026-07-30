#!/bin/bash

# scripts/docker-root/ssh.sh

set -euo pipefail

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  apt-get update
  apt-get install -y --no-install-recommends openssh-server

  mkdir -p /var/run/sshd
  cat <<EOF >>/etc/ssh/sshd_config
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
