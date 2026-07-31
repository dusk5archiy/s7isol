#!/bin/bash

# ------------------------------------------------------------------------------

if [[ -z "$S7ISOL_ROOT" ]]; then
  echo "S7ISOL_ROOT is not set"
  exit 1
fi

/usr/bin/mkdir -p "$S7ISOL_ROOT"

# ------------------------------------------------------------------------------

export HOME="$S7ISOL_ROOT/home"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export TMP="$HOME/tmp"
export TEMP="$TMP"

# ------------------------------------------------------------------------------

/usr/bin/mkdir -p $HOME \
  "$XDG_CONFIG_HOME" \
  "$XDG_DATA_HOME" \
  "$XDG_CACHE_HOME" \
  "$XDG_STATE_HOME" \
  "$TMP"

# ------------------------------------------------------------------------------

PROFILE_FILE="$HOME/.profile"
/usr/bin/cat "$S7ISOL/etc/start/.profile" >"$PROFILE_FILE"

# ------------------------------------------------------------------------------

BASHRC_FILE="$HOME/.bashrc"
/usr/bin/cat "$S7ISOL/etc/start/bashrc-ubuntu.sh" >"$BASHRC_FILE"
/usr/bin/cat "$S7ISOL/etc/start/bashrc-final.sh" >>"$BASHRC_FILE"
