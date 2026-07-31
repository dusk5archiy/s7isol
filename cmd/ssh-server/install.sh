#!/bin/bash

set -euo pipefail

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends openssh-server

  sudo mkdir -p /var/run/sshd
  sudo cat <<EOF >>/etc/ssh/sshd_config
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
