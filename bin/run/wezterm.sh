#!/bashrc

source "$S7ISOL/src/wezterm/env.sh"
/usr/bin/wezterm-gui >/dev/null 2>&1 &
disown
