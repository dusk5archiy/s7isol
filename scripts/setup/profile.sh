if [[ $0 != "${BASH_SOURCE[0]}" ]]; then
  echo "[-- bash --]"
  return 1
fi

# ------------------------------------------------------------------------------

. "$S7ISOL/bin/post.env.sh"

mkdir -p "$HOME" \
  "$XDG_CONFIG_HOME" \
  "$XDG_DATA_HOME" \
  "$XDG_CACHE_HOME" \
  "$XDG_STATE_HOME" \
  "$TMP"

mkdir -p "$HOME/bin"
mkdir -p "$HOME/.local/bin"

# ------------------------------------------------------------------------------

BashrcFile=$HOME/.bashrc

case $(. /etc/os-release && echo $ID) in
ubuntu)
  ProfileFile=$HOME/.profile
  cat "$S7ISOL/etc/start/.profile" >"$ProfileFile"
  cat "$S7ISOL/etc/start/bashrc-ubuntu.sh" >"$BashrcFile"
  cat "$S7ISOL/etc/start/bashrc-ubuntu-final.sh" >>"$BashrcFile"
  ;;
arch)
  cat "$S7ISOL/etc/start/bashrc-arch.sh" >"$BashrcFile"
  cat "$S7ISOL/etc/start/bashrc-arch-final.sh" >>"$BashrcFile"
  ;;
esac
