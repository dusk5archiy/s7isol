Main() {
  local Os && Os=$(. /etc/os-release && echo $ID)
  case $Os in
  arch)
    sudo pacman -S --noconfirm --needed kitty
    ;;
  *)
    echo "[-- error --] unsupported platform: $Os"
    return 1
    ;;
  esac
}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
