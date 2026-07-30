#!/usr/bin/env bash

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  sudo apt update
  sudo apt upgrade
  ;;
esac
