case $(. /etc/os-release && echo $ID) in
arch)
  cd /tmp || exit 1
  sudo pacman -S --noconfirm --needed git base-devel
  if [[ ! -d yay ]]; then git clone https://aur.archlinux.org/yay.git; fi
  cd yay || exit 1
  makepkg -si
  cd ..
  rm -rf yay
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac

echo "[-- done --] ${BASH_SOURCE[0]}"
