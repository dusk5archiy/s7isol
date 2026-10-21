Main() {
  local File=$1
  if [[ $File == *.rar ]]; then
    unrar l "$File"
  elif [[ $File == *.zip ]]; then
    unzip -l "$File"
  fi
  echo "[-- done --] ${BASH_SOURCE[0]}"
}

Main "$@"
