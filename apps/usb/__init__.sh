#!/bin/bash
set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  lsusb
  ;;
esac
