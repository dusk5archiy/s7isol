#!/bin/bash
set -euo pipefail

InterfaceName=wlp0s20f0u4

while true; do
  clear
  ip neigh show dev $InterfaceName
  sudo cat /var/lib/NetworkManager/dnsmasq-$InterfaceName.leases
  sleep 1
done
