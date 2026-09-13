Main() {
  mkdir -p /etc/cmdline.d
  echo "intel_iommu=on iommu=pt" | sudo tee /etc/cmdline.d/iommu.conf
  sudo mkinitcpio -P
}

Main "$@"
echo "[-- done --] ${BASH_SOURCE[0]}"
