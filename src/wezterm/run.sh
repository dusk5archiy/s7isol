#!/bashrc

# ------------------------------------------------------------------------------

if [[ ! -f "/usr/bin/wezterm-gui" ]]; then
  bash "$S7ISOL/bin/s7isol.sh" install/wezterm
fi

# ------------------------------------------------------------------------------

/usr/bin/wezterm-gui >/dev/null 2>&1 &
disown
