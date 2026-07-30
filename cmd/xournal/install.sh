#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  sudo apt-get install -y --no-install-recommends xournalpp
  ;;
esac
