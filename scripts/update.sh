#!/usr/bin/env bash

case "$S7ISOL_OS" in
ubuntu)
  $S7ISOL_SUDO apt update
  $S7ISOL_SUDO apt upgrade
  ;;
esac
