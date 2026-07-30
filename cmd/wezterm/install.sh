#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  sudo apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    gnupg
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
  sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends wezterm
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
