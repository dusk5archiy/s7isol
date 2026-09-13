Main() {
  local Host=$1 # XX:XX.X
  echo "0000:$Host" | sudo tee "/sys/bus/pci/devices/0000:$Host/driver/unbind" >/dev/null 2>&1 || true
  echo "0000:$Host" | sudo tee /sys/bus/pci/drivers_probe >/dev/null
}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
