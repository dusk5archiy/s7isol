#!/bin/bash

# ------------------------------------------------------------------------------

target="${1:-}"
shift # Remove $1 so "$@" holds only the remaining arguments
base="<|S7ISOL|>"
dirs=("scripts" "cmd" "apps" "env" "proj")

# ------------------------------------------------------------------------------

source "<|S7ISOL|>/bin/init.env.sh"

# ------------------------------------------------------------------------------
S7ISOL_PRE_ENV

# ------------------------------------------------------------------------------

source "<|S7ISOL|>/bin/post.env.sh"

# ------------------------------------------------------------------------------

if [[ "$0" != "$BASH_SOURCE" ]]; then
  for dir in "${dirs[@]}"; do
    file="$base/$dir/$target.sh"
    file_init="$base/$dir/$target/__init__.sh"
    if [[ -f "$file" ]]; then
      source "$file" "$@"
      return $?
    elif [[ -f "$file_init" ]]; then
      source "$file_init" "$@"
      return $?
    fi
  done
else
  for dir in "${dirs[@]}"; do
    file="$base/$dir/$target.sh"
    file_init="$base/$dir/$target/__init__.sh"
    if [[ -f "$file" ]]; then
      bash "$file" "$@"
      exit 0
    elif [[ -f "$file_init" ]]; then
      bash "$file_init" "$@"
      exit 0
    fi
  done
fi

# ------------------------------------------------------------------------------

if [[ -z "$target" ]]; then
  echo "$S7ISOL"
  exit 0
fi
