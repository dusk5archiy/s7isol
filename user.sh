Main() {
  local ModeWsl=0
  local ModeHypr=0
  local ModePrograms=0
  local ModeSetupProfile=0

  for Arg; do
    case $Arg in
    --wsl)
      ModeWsl=1
      ModeSetupProfile=1
      ModePrograms=1
      ;;
    --hypr)
      ModeHypr=1
      ;;
    --profile)
      ModeSetupProfile=1
      ;;
    --programs)
      ModePrograms=1
      ;;
    esac
  done

  local Os && Os=$(. /etc/os-release && echo $ID)
  case $Os in
  arch)
    ;;
  *)
    echo "[-- error --] unsupported platform" >&2
    return 1
    ;;
  esac

  local Dir && Dir=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
  bash "$Dir/setup/user-setup.sh"

  if [[ $ModeHypr == 1 ]]; then
    bash "$Dir/setup/user-hypr.sh"
  fi

  local InstallFlags=()

  if [[ $ModeSetupProfile == 1 ]]; then
    InstallFlags+=(--profile)
  fi

  bash "$Dir/install.sh" "${InstallFlags[@]}"

  if [[ $ModePrograms == 1 ]]; then
    bash "$Dir/setup/user-programs.sh"
  fi

  if [[ $ModeWsl == 1 ]]; then
    echo "[-- success --] Run:"
    echo "(Exit WSL) exit"
    echo "(Shutdown WSL) wsl --shutdown"
    echo "(Open WSL) wsl -d archlinux"
  fi
}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
