#!/bin/bash

set -euo pipefail

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  apt-get update
  apt-get install -y --no-install-recommends openssh-server

  ssh-keygen -A 2>/dev/null || true
  mkdir -p /var/run/sshd
  cat <<EOF >>/etc/ssh/sshd_config
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no

PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

AcceptEnv *
EOF
  if [ -f /tmp/host_key.pub ]; then
    mkdir -p /home/adevuser/.ssh
    cat /tmp/host_key.pub >/home/adevuser/.ssh/authorized_keys

    chown -R adevuser:adevuser /home/adevuser/.ssh
    chmod 700 /home/adevuser/.ssh
    chmod 600 /home/adevuser/.ssh/authorized_keys
  fi
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
