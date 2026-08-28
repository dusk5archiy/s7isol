#!/bin/bash
set -euo pipefail

Dir=$(dirname "${BASH_SOURCE[0]}")
case $(. /etc/os-release && echo $ID) in
arch)
  set -x
  sudo create_ap --config "$Dir/ap.conf"
  ;;
esac
