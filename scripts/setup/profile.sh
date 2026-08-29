#!/bin/bash
set -euo pipefail

if [[ $0 != "${BASH_SOURCE[0]}" ]]; then
  echo "[-- bash --]"
  return 1
fi

# ------------------------------------------------------------------------------

. "$S7ISOL/bin/post.env.sh"

/usr/bin/mkdir -p "$HOME" \
  "$XDG_CONFIG_HOME" \
  "$XDG_DATA_HOME" \
  "$XDG_CACHE_HOME" \
  "$XDG_STATE_HOME" \
  "$TMP"

/usr/bin/mkdir -p "$HOME/bin"
/usr/bin/mkdir -p "$HOME/.local/bin"

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
