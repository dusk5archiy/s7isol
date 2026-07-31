#!/bin/bash

set -euo pipefail

TZ=Etc/UTC

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  apt-get update

  # ca-certificates: required for git clone
  apt-get install -y --no-install-recommends \
    sudo \
    git \
    ca-certificates \
    tzdata

  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
  echo $TZ >/etc/timezone
  dpkg-reconfigure --frontend noninteractive tzdata

  git config --global http.sslVerify false
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
