


case $(. /etc/os-release && echo $ID) in
ubuntu)
  # pipewire-bin: contains pw-play to play sounds
  # yaru-theme-sound: a sound library

  sudo apt-get install -y --no-install-recommends \
    pipewire-bin yaru-theme-sound
  ;;
arch)
  sudo pacman -S --noconfirm --needed \
    pipewire pipewire-audio pipewire-pulse sound-theme-freedesktop
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac

echo "[-- done --] ${BASH_SOURCE[0]}"
