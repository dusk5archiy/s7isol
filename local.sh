. "$(dirname "$0")/bin/init.sh"
. "$S7ISOL/etc/init/pre.env.sh"
bash "$S7ISOL/scripts/inject-exec.sh"

s7_unset
skj wezterm
