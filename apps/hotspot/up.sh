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
Ssid=s7isol
Password=genericpc
Subnet=192.168.57.1/24

if [[ -z $InterfaceName ]]; then
  echo "[-- Error --] No USB Wi-Fi interface found."
  exit 0
fi

case $(. /etc/os-release && echo $ID) in
arch)
  sudo nmcli connection delete Hotspot 2>/dev/null || true
  sudo nmcli device wifi hotspot \
    ifname "$InterfaceName" \
    ssid "$Ssid" \
    password "$Password"

  sudo nmcli connection modify Hotspot \
    ipv4.addresses "$Subnet"

  sudo nmcli connection up Hotspot
  ;;
*)
  echo "[-- Error --] Unsupported OS."
  exit 1
  ;;
esac
