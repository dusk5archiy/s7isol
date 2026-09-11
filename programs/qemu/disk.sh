


DiskFile=$1
Size=$2

case $DiskFile in
*.qcow2)
  qemu-img create -f qcow2 "$DiskFile" "$Size"
  ;;
*.vhdx)
  qemu-img create -f vhdx "$DiskFile" "$Size"
  ;;
*)
  qemu-img create "$DiskFile" "$Size"
  ;;
esac
