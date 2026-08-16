#!/bin/bash
set -euo pipefail

case "$(. /etc/os-release && echo "$ID")" in
ubuntu)
  sudo apt-get update
  sudo apt-get upgrade -y
  ;;
esac
