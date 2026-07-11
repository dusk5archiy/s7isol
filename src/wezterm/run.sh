#!/bashrc

# ------------------------------------------------------------------------------

if [[ ! -f "/usr/bin/wezterm" ]]; then
  bash "$S7ISOL/bin/s7isol.sh" install/wezterm
fi

# ------------------------------------------------------------------------------

/usr/bin/wezterm start --cwd . >/dev/null 2>&1 &
disown
