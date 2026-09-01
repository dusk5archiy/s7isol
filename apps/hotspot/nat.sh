#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  sudo iptables -L FORWARD -n -v
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac
