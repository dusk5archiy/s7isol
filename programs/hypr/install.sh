Main() {
  local Os && Os=$(. /etc/os-release && echo $ID)
  case $Os in
  arch)
    sudo pacman -S --noconfirm --needed \
      hyprpolkitagent \
      hyprlauncher \
      xdg-desktop-portal-hyprland \
      hyprpaper \
      quickshell \
      mako \
      wl-clipboard
    ;;
  *)
    echo "[-- error --] unsupported platform" >&2
    return 1
    ;;
  esac
  cat <<EOF >"$HOME/.config/hypr/hyprland.lua"
local config = dofile("$S7ISOL/config/hypr/config.lua")
config.func(hl)
EOF
}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
