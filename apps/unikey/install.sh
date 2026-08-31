set -euo pipefail

case $(. /etc/os-release && echo $ID) in
arch)
  sudo pacman -S --no-confirm --needed \
    fcitx5 fcitx5-unikey fcitx5-configtool fcitx5-gtk fcitx5-qt

  fcitx5-configtool
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac
