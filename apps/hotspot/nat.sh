#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  sudo iptables -L FORWARD -n -v
  ;;
*)
  echo "[-- error --] unsupported platform"
  exit 1
  ;;
esac
