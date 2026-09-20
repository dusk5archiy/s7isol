Main() {
  local Os && Os=$(. /etc/os-release && echo $ID)
  case $Os in
  arch)
    sudo pacman -S --noconfirm --needed \
      hyprpolkitagent \
      wl-clipboard
    # hyprpolkitagent -- Authentication agent
    # wl-clipboard -- Clipboard
    ;;
  *)
    echo "[-- error --] unsupported platform" >&2
    return 1
    ;;
  esac

}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
