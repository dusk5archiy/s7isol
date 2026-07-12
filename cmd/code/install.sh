#!/bin/bash

# ------------------------------------------------------------------------------

source ""

case "$S7ISOL_OS" in
ubuntu)
  sudo snap install --classic code
  ;;
esac
