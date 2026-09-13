Main() {
  local ModeWsl=0
  local ModeHome=0
  local Username=generic
  local Password=generic

  while [[ $# -gt 0 ]]; do
    local Arg=$1
    case $Arg in
    --username) shift && Username=$1 ;;
    --password) shift && Password=$1 ;;
    --home) ModeHome=1 ;;
    --wsl) ModeWsl=1 ;;
    esac
    shift
  done

  # Create User ----------------------------------------------------------------
  useradd -m -s /bin/bash "$Username"
  echo "$Username:$Password" | chpasswd
  echo "$Username ALL=(ALL) NOPASSWD:ALL" >"/etc/sudoers.d/$Username"

  # Home -----------------------------------------------------------------------
  if [[ $ModeHome == 1 ]]; then
    chown -R "$Username:$Username" "/home/$Username"
    chmod g+s "/home/$Username"
  fi

  # WSL ------------------------------------------------------------------------
  if [[ $ModeWsl == 1 && -f /etc/wsl.conf ]]; then
    cat <<EOF | sudo tee /etc/wsl.conf >/dev/null
[boot]
systemd=true

[user]
default=$Username
EOF
  fi
}

Main "$@"
