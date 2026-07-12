#!/bin/bash

# ------------------------------------------------------------------------------

OS="$(source /etc/os-release && echo $ID)"

case "$S7ISOL_OS" in
ubuntu)
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
  sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
  sudo apt update
  sudo apt install wezterm
  ;;
esac
