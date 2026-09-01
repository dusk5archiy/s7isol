#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  rpi-imager
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac
