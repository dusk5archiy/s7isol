# shellcheck source=/dev/null
Dir=$(dirname "${BASH_SOURCE[0]}")
if File=$Dir/../virenv/s7isol/env.sh && [[ -f $File ]]; then . "$File"; fi
