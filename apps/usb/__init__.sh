case $(. /etc/os-release && echo $ID) in
arch)
  lsusb
  ;;
esac
