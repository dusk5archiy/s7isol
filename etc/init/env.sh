#!/bin/bash

# ------------------------------------------------------------------------------

if [[ -z "$YOUR_SSH_DIR" ]]; then
  export YOUR_SSH_DIR="$HOME/.ssh"
fi

# ------------------------------------------------------------------------------

source "$S7ISOL/src/yazi/env.sh"
source "$S7ISOL/src/nvim/env.sh"
source "$S7ISOL/src/wezterm/env.sh"
