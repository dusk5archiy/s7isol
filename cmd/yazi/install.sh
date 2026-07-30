#!/usr/bin/env bash

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  sudo snap install --classic yazi
  ;;
esac
