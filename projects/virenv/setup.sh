# python -----------------------------------------------------------------------
case $(. /etc/os-release && echo $ID) in
ubuntu)
  sudo apt-get install -y --no-install-recommends \
    python3 python-is-python3 python3-venv
  ;;
arch)
  sudo pacman -S --noconfirm --needed \
    python
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac

# uv ---------------------------------------------------------------------------
case $(. /etc/os-release && echo $ID) in
ubuntu)
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ;;
arch)
  sudo pacman -S --noconfirm --needed \
    uv
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac

# make -------------------------------------------------------------------------
case $(. /etc/os-release && echo $ID) in
ubuntu)
  sudo apt-get install -y --no-install-recommends \
    make
  ;;
arch)
  sudo pacman -S --noconfirm --needed \
    make
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac
