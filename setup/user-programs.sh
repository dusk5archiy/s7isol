Main() {
  Dir=$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")
  export PATH="$HOME/bin:$PATH"
  bash "$Dir/programs/wezterm/install.sh"
  bash "$Dir/programs/y/install.sh"
  bash "$Dir/programs/sound/install.sh"
  bash "$Dir/programs/nvim-qt/install.sh"
  bash "$Dir/programs/fonts/gui.sh"

  bash "$Dir/programs/nvim/install.sh"
}

Main "$@"
