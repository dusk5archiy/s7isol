#!/usr/bin/env bash

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  sudo apt-get update
  sudo apt-get upgrade
  ;;
esac
