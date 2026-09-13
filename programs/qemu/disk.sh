Main() {
  local DiskFile=$1
  local Size=$2
  local FileExtension="${DiskFile##*.}"

  case $DiskFile in
  *.qcow2 | *.vhdx)
    qemu-img create -f "$FileExtension" "$DiskFile" "$Size"
    ;;
  *)
    qemu-img create "$DiskFile" "$Size"
    ;;
  esac
}

Main "$@"

echo "[-- done --] ${BASH_SOURCE[*]}"
