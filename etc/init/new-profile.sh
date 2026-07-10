#!/bin/bash

# ------------------------------------------------------------------------------

if [[ -z "$S7ISOL_ROOT" ]]; then
  echo "S7ISOL_ROOT is not set"
  exit 1
fi

# ------------------------------------------------------------------------------

/usr/bin/mkdir -p "$S7ISOL_ROOT"

# ------------------------------------------------------------------------------

export HOME="$S7ISOL_ROOT/home"

# ------------------------------------------------------------------------------

source $S7ISOL/etc/init/home.env.sh

# ------------------------------------------------------------------------------

/usr/bin/mkdir -p $HOME \
  "$XDG_CONFIG_HOME" \
  "$XDG_DATA_HOME" \
  "$XDG_CACHE_HOME" \
  "$XDG_STATE_HOME" \
  "$TMP"

# ------------------------------------------------------------------------------

PROFILE_FILE="$HOME/.profile"

# ------------------------------------------------------------------------------

if [[ ! -f "$PROFILE_FILE" || -n "$FORCE_INIT" ]]; then
  /usr/bin/rm -f "$PROFILE_FILE"
  /usr/bin/touch "$PROFILE_FILE"
  /usr/bin/cat "$S7ISOL/etc/start/.profile" >>"$PROFILE_FILE"
fi

# ------------------------------------------------------------------------------

BASHRC_FILE="$HOME/.bashrc"

# ------------------------------------------------------------------------------

if [[ ! -f "$BASHRC_FILE" || -n "$FORCE_INIT" ]]; then
  /usr/bin/rm -f "$BASHRC_FILE"
  /usr/bin/touch "$BASHRC_FILE"

  /usr/bin/cat "$S7ISOL/etc/start/bashrc-ubuntu.sh" >>"$BASHRC_FILE"
  /usr/bin/cat "$S7ISOL/etc/start/bashrc-final.sh" >>"$BASHRC_FILE"
fi
