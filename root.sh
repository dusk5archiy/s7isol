Main() {
  local Os && Os=$(. /etc/os-release && echo $ID)
  case $Os in
  arch)
    ;;
  *)
    echo "[-- error --] unsupported platform" >&2
    exit 1
    ;;
  esac

  pacman -Syu --noconfirm
  pacman -S --noconfirm --needed sudo

  local Username Password

  echo "[-- prompt --] Create a New User"
  read -rp "Username: " Username
  read -rsp "Password: " Password
  echo ""

  local Dir && Dir=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
  bash "$Dir/setup/root-create-user.sh" \
    --username "$Username" \
    --password "$Password" \
    --wsl

  su - "$Username" -c "bash $Dir/user.sh"
}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
