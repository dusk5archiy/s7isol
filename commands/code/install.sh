#!/bin/bash
Set -euo pipefail

# ------------------------------------------------------------------------------

case $(. /etc/os-release && echo "$ID") in
ubuntu)
  sudo snap install --classic code
  ;;
esac
