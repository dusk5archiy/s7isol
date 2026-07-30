#!/usr/bin/env bash

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  sudo apt-get install -y --no-install-recommends xournalpp
  ;;
esac
