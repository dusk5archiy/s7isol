#!/bin/bash

set -euo pipefail

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  apt-get update
  apt-get install -y --no-install-recommends \
    sudo git
  git config --global http.sslVerify false
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
