Main() {
  local Host=$1 # XX:XX.X
  local Dir && Dir=$(dirname "${BASH_SOURCE[0]}")
  echo "vfio-pci" | sudo tee "/sys/bus/pci/devices/0000:$Host/driver_override" >/dev/null
  bash "$Dir/refresh.sh" "$Host"
}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
