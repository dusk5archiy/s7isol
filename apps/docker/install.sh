#!/usr/bin/env bash

case "$S7ISOL_OS" in
ubuntu)
  sudo apt install docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  ;;
esac
