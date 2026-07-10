#!/bin/bash

# ------------------------------------------------------------------------------

if [[ "$0" != "$BASH_SOURCE" ]]; then
  return 1
fi

# ------------------------------------------------------------------------------

if [[ -z "$S7ISOL_ROOT" ]]; then
  echo "S7ISOL_ROOT is not set"
  exit 1
fi

# ------------------------------------------------------------------------------

/usr/bin/mkdir -p "$S7ISOL_ROOT"

# ------------------------------------------------------------------------------

export HOME="$S7ISOL_ROOT/home"
/usr/bin/mkdir -p $HOME

# ------------------------------------------------------------------------------

source "$(dirname "$0")/bin/env.sh"
source "/etc/environment"

# ------------------------------------------------------------------------------

source "$S7ISOL/etc/init/pre.env.sh"
source "$S7ISOL/etc/init/new-profile.sh"
source "$S7ISOL/etc/init/s7isol.sh"
source "$S7ISOL/etc/init/post.env.sh"
source "$S7ISOL/etc/init/env.sh"

# ------------------------------------------------------------------------------

if [[ -z "$S7ISOL_RUN_FN" ]]; then
  echo "S7ISOL_RUN_FN is not defined."
  exit 1
fi

$S7ISOL_RUN_FN
