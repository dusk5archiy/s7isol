#!/usr/bin/env bash
set -euo pipefail

# Default UID/GID if not provided
PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

echo "🔧 Setting up user with UID: $PUID, GID: $PGID"

# Remove existing ubuntu user if it exists (common in base images)
if id "ubuntu" &>/dev/null; then
  echo "📝 Removing existing 'ubuntu' user..."
  userdel -r ubuntu 2>/dev/null || true
fi

# Remove existing ubuntu group if it exists
if getent group ubuntu &>/dev/null; then
  echo "📝 Removing existing 'ubuntu' group..."
  groupdel ubuntu 2>/dev/null || true
fi

# Create or find group with PGID
if ! getent group "$PGID" &>/dev/null; then
  echo "📝 Creating group with GID: $PGID"
  groupadd -g "$PGID" adevuser
  DEV_GROUP="adevuser"
else
  DEV_GROUP=$(getent group "$PGID" | cut -d: -f1)
  echo "📝 Using existing group: $DEV_GROUP (GID: $PGID)"
fi

# Create user if it doesn't exist
if ! id -u adevuser &>/dev/null; then
  echo "📝 Creating user adevuser with UID: $PUID"
  useradd -m -s /bin/bash -u "$PUID" -g "$DEV_GROUP" adevuser
  echo "adevuser:adevuser" | chpasswd
else
  echo "📝 User 'adevuser' already exists"
  # Ensure user has correct UID/GID
  usermod -u "$PUID" -g "$DEV_GROUP" adevuser 2>/dev/null || true
fi

# Set up sudo access
mkdir -p /etc/sudoers.d
echo "adevuser ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/adevuser
chmod 0440 /etc/sudoers.d/adevuser

# Fix ownership of home directory
if [ -d "/home/adevuser" ]; then
  echo "📝 Fixing ownership of /home/adevuser"
  chown -R adevuser:"$DEV_GROUP" /home/adevuser
fi

# Fix ownership of workspace if it exists
if [ -d "/workspace" ]; then
  echo "📝 Fixing ownership of /workspace"
  chown -R adevuser:"$DEV_GROUP" /workspace 2>/dev/null || true
fi

# Fix ownership of any mounted volumes
# This is a common pattern for dev containers
if [ -d "/home/adevuser/.config" ]; then
  chown -R adevuser:"$DEV_GROUP" /home/adevuser/.config 2>/dev/null || true
fi

echo "✅ User setup complete!"
echo "   User: adevuser (UID: $PUID, GID: $PGID)"
echo "   Home: /home/adevuser"
