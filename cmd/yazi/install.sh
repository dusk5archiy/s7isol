#!/bin/bash

# ------------------------------------------------------------------------------

OS="$(source /etc/os-release && echo $ID)"

case "$S7ISOL_OS" in
ubuntu)
  sudo snap install --classic yazi
  ;;
esac
