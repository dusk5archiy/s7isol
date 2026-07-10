#!/bin/bash

set -e

# ------------------------------------------------------------------------------

if [[ "$0" != "$BASH_SOURCE" ]]; then
  return 1
fi

if [[ -n "$S7ISOL" ]]; then
  exit 1
fi

# ------------------------------------------------------------------------------

force_setup="$1"

# ------------------------------------------------------------------------------

source bin/env.sh

# ------------------------------------------------------------------------------

if [[ -f "$S7ISOL/.env" ]]; then
  source "$S7ISOL/.env"
else
  source "$S7ISOL/example.env"
fi

if [[ -z "$S7ISOL_ROOT" ]]; then
  echo "Please set S7ISOL_ROOT"
  exit 1
fi

/usr/bin/mkdir -p "$S7ISOL_ROOT"

# ------------------------------------------------------------------------------

export HOME="$S7ISOL_ROOT/home"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache" export XDG_STATE_HOME="$HOME/.local/state"
export TMP="$HOME/tmp"
export TEMP="$TMP"

/usr/bin/mkdir -p $HOME \
  "$XDG_CONFIG_HOME" \
  "$XDG_DATA_HOME" \
  "$XDG_CACHE_HOME" \
  "$XDG_STATE_HOME" \
  "$TMP" \
  "$APPS_DIR"

# ------------------------------------------------------------------------------

PROFILE_FILE="$HOME/.profile"

if [[ ! -f "$PROFILE_FILE" || "$force_setup" == "1" ]]; then
  /usr/bin/rm -f "$PROFILE_FILE"
  /usr/bin/touch "$PROFILE_FILE"
  /usr/bin/cat "$S7ISOL/etc/.profile" >>"$PROFILE_FILE"
fi

# ------------------------------------------------------------------------------

BASHRC_FILE="$HOME/.bashrc"

if [[ ! -f "$BASHRC_FILE" || "$force_setup" == "1" ]]; then
  /usr/bin/rm -f "$BASHRC_FILE"
  /usr/bin/touch "$BASHRC_FILE"

  /usr/bin/cat "$S7ISOL/etc/bashrc-ubuntu.sh" >>"$BASHRC_FILE"
  /usr/bin/cat "$S7ISOL/etc/bashrc-final.sh" >>"$BASHRC_FILE"
fi

# ------------------------------------------------------------------------------

S7ISOL_FILE="$HOME/bin/s7isol"
if [[ ! -f "$S7ISOL_FILE" || "$force_setup" == "1" ]]; then
  /usr/bin/mkdir -p "$HOME/bin"
  /usr/bin/rm -f "$S7ISOL_FILE"
  /usr/bin/touch "$S7ISOL_FILE"
  /usr/bin/cat "$S7ISOL/etc/s7isol.sh" >>"$S7ISOL_FILE"
  /usr/bin/chmod +x "$S7ISOL_FILE"
fi

# ------------------------------------------------------------------------------

if [[ "$force_setup" == "1" ]]; then
  /usr/bin/bash "$S7ISOL/src/vscode/init.sh"
fi

# ------------------------------------------------------------------------------

if [[ -z "$S7ISOL_RUN_FN" ]]; then
  echo "S7ISOL_RUN_FN is not defined."
  exit 1
fi

$S7ISOL_RUN_FN
