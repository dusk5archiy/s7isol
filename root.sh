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

  echo "[-- prompt --] Create a New User"
  if [[ -z $Username ]]; then
    read -rp "Username: " Username
  fi

  local Dir && Dir=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
  bash "$Dir/setup/root-create-user.sh" --username "$Username" --wsl
  su - "$Username" -c "bash $Dir/user.sh"
}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
