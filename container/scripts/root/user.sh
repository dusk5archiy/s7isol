#!/bin/bash
set -euo pipefail

# Default UID/GID if not provided
PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

echo "🔧 Setting up user with UID: $PUID, GID: $PGID"

# 1. Remove existing default 'ubuntu' user/group if present
if id "ubuntu" &>/dev/null; then
  echo "📝 Removing existing 'ubuntu' user..."
  userdel -r ubuntu 2>/dev/null || true
fi

if getent group ubuntu &>/dev/null; then
  echo "📝 Removing existing 'ubuntu' group..."
  groupdel ubuntu 2>/dev/null || true
fi

# 2. Create group with $PGID if no group currently uses it
if ! getent group "$PGID" &>/dev/null; then
  echo "📝 Creating group with GID: $PGID"
  groupadd -g "$PGID" adevuser
fi

# 3. Create or update user directly with numeric GID ($PGID)
if ! id -u adevuser &>/dev/null; then
  echo "📝 Creating user adevuser with UID: $PUID"
  useradd -m -s /bin/bash -u "$PUID" -g "$PGID" adevuser
  echo "adevuser:adevuser" | chpasswd
else
  echo "📝 User 'adevuser' already exists"
  usermod -u "$PUID" -g "$PGID" adevuser 2>/dev/null || true
fi

# 4. Set up sudo access
mkdir -p /etc/sudoers.d
echo "adevuser ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/adevuser
chmod 0440 /etc/sudoers.d/adevuser

# 5. Fix ownership using trailing colon (adevuser: automatically uses primary group)
for dir in "/home/adevuser" "/workspace" "/home/adevuser/.config"; do
  if [ -d "$dir" ]; then
    echo "📝 Fixing ownership of $dir"
    chown -R adevuser: "$dir" 2>/dev/null || true
  fi
done

echo "✅ User setup complete!"
echo "   User: adevuser (UID: $PUID, GID: $PGID)"
echo "   Home: /home/adevuser"
