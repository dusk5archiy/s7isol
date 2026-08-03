#!/bin/bash
set -euo pipefail

# Guard: Must be run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "⚠️ Script is not running as root. Skipping system user creation."
  exit 0
fi

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

echo "🔧 Setting up user with UID: $PUID, GID: $PGID"

# Check if the user or group already exists with correct IDs
if id -u adevuser &>/dev/null && [ "$(id -u adevuser)" -eq "$PUID" ] && [ "$(id -g adevuser)" -eq "$PGID" ]; then
  echo "✅ User 'adevuser' already exists with correct UID:GID ($PUID:$PGID)"
  exit 0
fi

# Only remove if the user exists and is NOT the current user running the script
CURRENT_USER=$(whoami)
EXISTING_USER=$(id -nu "$PUID" 2>/dev/null || true)
if [ -n "$EXISTING_USER" ] && [ "$EXISTING_USER" != "adevuser" ] && [ "$EXISTING_USER" != "$CURRENT_USER" ]; then
  echo "📝 Removing conflicting user '$EXISTING_USER' (UID: $PUID)..."
  # Kill processes before removal
  pkill -u "$EXISTING_USER" 2>/dev/null || true
  userdel -r "$EXISTING_USER" 2>/dev/null || true
fi

# Create group if needed
if ! getent group "$PGID" &>/dev/null; then
  groupadd -g "$PGID" adevuser 2>/dev/null || groupadd adevuser
fi

# Create user without password
if ! id -u adevuser &>/dev/null; then
  useradd -m -s /bin/bash -u "$PUID" -g "$PGID" adevuser --disabled-password
else
  usermod -u "$PUID" -g "$PGID" adevuser 2>/dev/null || true
fi

# Set up home directory only if it's new
if [ ! -f "/home/adevuser/.bashrc" ]; then
  cp /etc/skel/.bashrc /home/adevuser/ 2>/dev/null || true
  echo "export PS1='\u@\h:\w\$ '" >>/home/adevuser/.bashrc
fi

# Fix home directory ownership (non-recursive unless needed)
chown adevuser:adevuser /home/adevuser 2>/dev/null || true

# Fix /workspace if it exists and is empty
if [ -d "/workspace" ]; then
  # Check if directory is mounted and contains files
  if [ -z "$(ls -A /workspace 2>/dev/null)" ]; then
    chown adevuser:adevuser /workspace 2>/dev/null || true
  fi
fi

echo "✅ User setup complete!"
echo "   User: adevuser (UID: $(id -u adevuser), GID: $(id -g adevuser))"
echo "   Home: /home/adevuser"
