export S7ISOL_OS="$(source /etc/os-release && echo $ID)"

# ------------------------------------------------------------------------------

case "$S7ISOL_OS" in
msys2)
  export S7ISOL_SUDO=""
  ;;
*)
  export S7ISOL_SUDO="sudo"
  ;;
esac
