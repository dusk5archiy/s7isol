case $(. /etc/os-release && echo $ID) in
arch)
  sudo pacman -S --noconfirm --needed \
    typst
  ;;
*)
  echo "[-- error --] unsupported platform"
  ;;
esac
