#!/bin/bash
set -euo pipefail

if [[ $0 != "${BASH_SOURCE[0]}" ]]; then
  echo "[-- bash --]"
  return 1
fi

# ------------------------------------------------------------------------------

BashrcFile=$HOME/.bashrc

case $(. /etc/os-release && echo $ID) in
ubuntu)
  ProfileFile=$HOME/.profile
  /usr/bin/cat "$S7ISOL/etc/start/.profile" >"$ProfileFile"
  /usr/bin/cat "$S7ISOL/etc/start/bashrc-ubuntu.sh" >"$BashrcFile"
  /usr/bin/cat "$S7ISOL/etc/start/bashrc-ubuntu-final.sh" >>"$BashrcFile"
  ;;
arch)
  /usr/bin/cat "$S7ISOL/etc/start/bashrc-arch.sh" >"$BashrcFile"
  /usr/bin/cat "$S7ISOL/etc/start/bashrc-arch-final.sh" >>"$BashrcFile"
  ;;
esac
