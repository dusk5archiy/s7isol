#!/bin/bash
set -euo pipefail

# 1. Set Regional Mirror & Timezone
TZ="Asia/Ho_Chi_Minh"
sed -i 's|archive.ubuntu.com|vn.archive.ubuntu.com|g' /etc/apt/sources.list.d/ubuntu.sources 2>/dev/null || true
sed -i 's|archive.ubuntu.com|vn.archive.ubuntu.com|g' /etc/apt/sources.list 2>/dev/null || true

# 2. Exclude Documentation & Translations from dpkg unpacking (Dramatically cuts disk I/O)
cat <<EOF >/etc/dpkg/dpkg.cfg.d/01_nodoc
path-exclude /usr/share/doc/*
path-exclude /usr/share/man/*
path-exclude /usr/share/groff/*
path-exclude /usr/share/info/*
path-exclude /usr/share/lintian/*
path-exclude /usr/share/linda/*
EOF

# 3. Optimize APT Network (GET) & Disk Settings
cat <<EOF >/etc/apt/apt.conf.d/99faster
DPkg::Options { "--force-confdef"; "--force-confold"; };
force-unsafe-io;
Acquire::Languages "none";
Acquire::http::Pipeline-Depth "10";
Acquire::http::No-Cache "true";
Acquire::Retries "3";
EOF

# 4. Non-interactive Timezone setup before package install
ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime
echo "$TZ" >/etc/timezone

# 5. Fast Package Install (Includes 'eatmydata' to bypass disk syncs)
apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl wget git \
  sudo \
  tzdata \
  vim

# 6. Global Git Config
git config --global http.sslVerify false
