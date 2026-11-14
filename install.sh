Main() {
  local OptionSetupProfile=0
  local OptionInjectExec=1

  for Arg; do
    case $Arg in
    --profile)
      OptionSetupProfile=1
      ;;
    esac
  done

  local Dir && Dir=$(dirname "$(realpath "${BASH_SOURCE[0]}")")

  # ----------------------------------------------------------------------------
  . "$Dir/bin/init.sh"

  if [[ $OptionInjectExec == 1 ]]; then
    bash "$Dir/scripts/inject-exec.sh"
  fi

  s7_unset

  # ----------------------------------------------------------------------------
  if [[ $OptionSetupProfile == 1 ]]; then
    skj setup/profile
  fi
}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
