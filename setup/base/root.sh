#!/bin/bash
set -euo pipefail

# Docker -----------------------------------------------------------------------
rm -f /etc/apt/apt.conf.d/docker-clean

# Setting APT mirror -----------------------------------------------------------
get_country_code() {
  exec 3<>/dev/tcp/ipapi.co/80
  echo -e "GET /country/ HTTP/1.1\r\nHost: ipapi.co\r\nUser-Agent: bash\r\nConnection: close\r\n\r\n" >&3

  # Read response line by line until body
  while read -r line; do
    if [[ "$line" == $'\r' || -z "$line" ]]; then
      read -r body
      echo "$body" | tr '[:upper:]' '[:lower:]' | tr -d '\r\n'
      break
    fi
  done <&3
  exec 3>&-
}

COUNTRY_CODE=$(get_country_code 2>/dev/null || true)

if [[ "$COUNTRY_CODE" =~ ^[a-z]{2}$ ]]; then
  REGIONAL_MIRROR="${COUNTRY_CODE}.archive.ubuntu.com"
  echo "[-- Switching mirror to: ${REGIONAL_MIRROR} --]"

  [ -f /etc/apt/sources.list.d/ubuntu.sources ] && sed -i "s|archive.ubuntu.com|${REGIONAL_MIRROR}|g" /etc/apt/sources.list.d/ubuntu.sources
  [ -f /etc/apt/sources.list ] && sed -i "s|archive.ubuntu.com|${REGIONAL_MIRROR}|g" /etc/apt/sources.list
else
  echo "[-- Fallback: using default archive mirror --]"
fi

# Disaable Source Repositories -------------------------------------------------
[ -f /etc/apt/sources.list ] && sed -i '/^deb-src/s/^/#/' /etc/apt/sources.list
[ -f /etc/apt/sources.list.d/ubuntu.sources ] && sed -i 's/Types: deb deb-src/Types: deb/g' /etc/apt/sources.list.d/ubuntu.sources

# Dpkg Extraction Optimizations ------------------------------------------------
cat <<EOF >/etc/dpkg/dpkg.cfg.d/01_nodoc
path-exclude /usr/share/doc/*
path-exclude /usr/share/man/*
path-exclude /usr/share/groff/*
path-exclude /usr/share/info/*
path-exclude /usr/share/lintian/*
path-exclude /usr/share/linda/*
path-exclude /usr/share/locale/*
path-include /usr/share/locale/en*
EOF

# Native APT Performance Tuning ------------------------------------------------
cat <<EOF >/etc/apt/apt.conf.d/99faster
DPkg::Options {
  "--force-confdef";
  "--force-confold";
  "--force-unsafe-io";
};

// Enable parallel downloads (16 threads)
APT::Acquire::Max-Parallel-Downloads "16";

// Skip generating local binary caches
Dir::Cache::pkgcache "";
Dir::Cache::srcpkgcache "";

// Network and Index optimizations
Acquire::ForceIPv4 "true";
Acquire::Languages "none";
Acquire::PDiffs "false";
Acquire::By-Hash "false";
Acquire::http::Pipeline-Depth "5";
Acquire::http::No-Cache "true";
Acquire::Retries "3";
Acquire::Queue-Mode "host";
EOF

export DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------------------------
TZ="Asia/Ho_Chi_Minh"
ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime
echo "$TZ" >/etc/timezone

# Essentials -------------------------------------------------------------------
apt-get update
apt-get install -y --no-install-recommends sudo git

# Git --------------------------------------------------------------------------
git config --system http.sslVerify false
git config --system --add safe.directory "*"

# User -------------------------------------------------------------------------
awk -F: '$3 >= 1000 && $3 < 60000 {print $1}' /etc/passwd | xargs -r -n1 userdel -r 2>/dev/null || true
useradd -m -s /bin/bash "$CONFIG_USERNAME"
echo "$CONFIG_USERNAME:$CONFIG_USERNAME" | chpasswd
chown -R "$CONFIG_USERNAME:$CONFIG_USERNAME" "/home/$CONFIG_USERNAME"
echo "$CONFIG_USERNAME ALL=(ALL) NOPASSWD:ALL" >"/etc/sudoers.d/$CONFIG_USERNAME"

groupadd -g 990 -o render
usermod -aG video "$CONFIG_USERNAME"
usermod -aG render "$CONFIG_USERNAME"
