case $(. /etc/os-release && echo $ID) in
arch)
  sudo pacman -S --noconfirm --needed \
    okular
  ;;
*)
  echo "[-- error --] unsupported platform"
  ;;
esac
