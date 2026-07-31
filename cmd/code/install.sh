#!/bin/bash

# ------------------------------------------------------------------------------

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  sudo snap install --classic code
  ;;
esac
