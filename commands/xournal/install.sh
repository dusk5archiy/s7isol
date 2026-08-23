#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo "$ID") in
ubuntu)
  sudo apt-get install -y --no-install-recommends xournalpp
  ;;
esac
