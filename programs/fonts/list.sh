#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  ls /usr/share/kbd/consolefonts/
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
