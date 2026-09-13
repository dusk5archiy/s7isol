Main() {
  local ModeSetupProfile=0
  local ModeAddExec=1

  for Arg; do
    case $Arg in
    --profile)
      ModeSetupProfile=1
      ;;
    esac
  done

  local Dir && Dir=$(dirname "${BASH_SOURCE[0]}")

  # ------------------------------------------------------------------------------
  . "$Dir/bin/init.sh"

  if [[ $ModeAddExec == 1 ]]; then
    bash "$Dir/scripts/new-exec.sh"
  fi

  s7_unset
  # ------------------------------------------------------------------------------

  if [[ $ModeSetupProfile == 1 ]]; then
    "$HOME/bin/skj" setup/profile
  fi
}

Main "$@"
