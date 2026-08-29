#!/bin/bash
set -euo pipefail

ArgSetupProfile=

for Arg; do
  case $Arg in
  --profile)
    ArgSetupProfile=1
    ;;
  esac
done

Dir=$(dirname "${BASH_SOURCE[0]}")

# ------------------------------------------------------------------------------
. "$Dir/bin/init.sh"
bash "$Dir/scripts/new-exec.sh"

s7_unset
# ------------------------------------------------------------------------------

if [[ -n $ArgSetupProfile ]]; then
  "$HOME/bin/skj" setup/profile
fi
