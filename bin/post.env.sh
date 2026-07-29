if [[ -f "$S7ISOL/.post.env" ]]; then
  source "$S7ISOL/.post.env"
else
  source "$S7ISOL/default.post.env"
fi

# ------------------------------------------------------------------------------

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
export XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-"$HOME/.cache"}
export XDG_STATE_HOME=${XDG_STATE_HOME:-"$HOME/.local/state"}
export TMP=${TMP:-"$HOME/tmp"}
export TEMP="$TMP"

# ------------------------------------------------------------------------------

for file in "$S7ISOL/env"/*.sh; do
  source "$file"
done
