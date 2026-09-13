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

  local Dir && Dir=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
  bash "$Dir/setup/user-setup.sh"
  bash "$Dir/install.sh" --profile
  bash "$Dir/setup/user-programs.sh"

  echo "[-- success --] Run:"
  echo "(Exit WSL) exit"
  echo "(Shutdown WSL) wsl --shutdown"
  echo "(Open WSL) wsl -d archlinux"
}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
