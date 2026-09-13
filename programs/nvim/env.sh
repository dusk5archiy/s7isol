Main() {
  local S7isol && S7isol=$(dirname "$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")")
  export NVIM_CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/nvim
  export S7ISOL_NVIM_CONFIG_DIR=${S7ISOL_NVIM_CONFIG_DIR:-$S7isol/config/nvim}
}

Main "$@"
unset -f Main
