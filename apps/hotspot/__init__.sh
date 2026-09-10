#!/bin/bash
set -euo pipefail

InterfaceName=$(
  for iface in /sys/class/net/*; do
    if [[ -d "$iface/wireless" ]] && readlink -f "$iface/device" | grep -q "/usb"; then
      basename "$iface"
      break
    fi
  done
  true
)

while true; do
  clear
  echo "InterfaceName: $InterfaceName"
  echo "[-- exec --] ip neigh show dev $InterfaceName"
  ip neigh show dev "$InterfaceName"
  echo "[-- exec --] sudo cat /var/lib/NetworkManager/dnsmasq-${InterfaceName}.leases"
  sudo cat "/var/lib/NetworkManager/dnsmasq-$InterfaceName.leases"
  sleep 1
done
