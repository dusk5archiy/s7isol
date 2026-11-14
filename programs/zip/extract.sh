Main() {
  local File=$1
  if [[ $File == *.rar ]]; then
    unrar x "$File"
  elif [[ $File == *.zip ]]; then
    unzip "$File"
  fi
  echo "[-- done --] ${BASH_SOURCE[0]}"
}

Main "$@"
