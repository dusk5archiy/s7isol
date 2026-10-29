Main() {
  local Os && Os=$(. /etc/os-release && echo $ID)
  case $Os in
  arch)
    s7_unset
    xdg-open "$@"
    ;;
  *)
    echo "[-- error --] unsupported platform" >&2
    return 1
    ;;
  esac
}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
