Main() {

  local Os && Os=$(. /etc/os-release && echo $ID)

  case $Os in
  arch)
    sudo pacman -Syu --no-confirm
    sudo pacman -S --noconfirm --needed \
      ca-certificates \
      curl \
      git \
      gnupg \
      less \
      sudo \
      unzip \
      vim \
      wget \
      which
    ;;
  esac

  sudo git config --system http.sslVerify false
  sudo git config --system --add safe.directory "*"
}

Main "$@"
