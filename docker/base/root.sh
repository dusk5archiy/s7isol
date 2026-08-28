#!/bin/bash
set -euo pipefail

Os=$(. /etc/os-release && echo $ID)

# Docker -----------------------------------------------------------------------
if [[ $Os == ubuntu ]]; then
  rm -f /etc/apt/apt.conf.d/docker-clean
fi

# Getting Country Code ---------------------------------------------------------
get_country_code() {
  exec 3<>/dev/tcp/ipapi.co/80
  echo -e "GET /country/ HTTP/1.1\r\nHost: ipapi.co\r\nUser-Agent: bash\r\nConnection: close\r\n\r\n" >&3

  # Read response line by line until body
  while read -r line; do
    if [[ $line == $'\r' || -z $line ]]; then
      read -r body
      echo "$body" | tr '[:upper:]' '[:lower:]' | tr -d '\r\n'
      break
    fi
  done <&3
  exec 3>&-
}

if [[ $Os == ubuntu ]]; then
  # [ Ubuntu ] Setting APT mirror ----------------------------------------------
  echo '[-- INFO --] Setting APT mirror...'

  CountryCode=$(get_country_code 2>/dev/null || true)
  if [[ $CountryCode =~ ^[a-z0-9]+$ ]]; then
    RegionMirror=$CountryCode.archive.ubuntu.com
    echo "[-- Switching mirror to: $RegionMirror --]"

    [ -f /etc/apt/sources.list.d/ubuntu.sources ] && sed -i "s|archive.ubuntu.com|$RegionMirror|g" /etc/apt/sources.list.d/ubuntu.sources
    [ -f /etc/apt/sources.list ] && sed -i "s|archive.ubuntu.com|$RegionMirror|g" /etc/apt/sources.list
  else
    echo "[-- Fallback: using default archive mirror --]"
  fi
  # [ Ubuntu ] Disaable Source Repositories ------------------------------------
  echo '[-- INFO --] Disable Source Repositories...'

  [ -f /etc/apt/sources.list ] && sed -i '/^deb-src/s/^/#/' /etc/apt/sources.list
  [ -f /etc/apt/sources.list.d/ubuntu.sources ] && sed -i 's/Types: deb deb-src/Types: deb/g' /etc/apt/sources.list.d/ubuntu.sources

  # [ Ubuntu ] Dpkg Extraction Optimizations -----------------------------------
  echo '[-- INFO --] Dpkg Extraction Optimizations...'
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

  # [ Ubuntu ] Native APT Performance Tuning -----------------------------------
  echo '[-- INFO --] Native APT Performance Tuning...'
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

fi # $Os == ubuntu -------------------------------------------------------------

export DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------------------------
if [[ $Os == ubuntu ]]; then
  echo '[-- INFO --] Setting Timezone...'
  Tz=Asia/Ho_Chi_Minh
  ln -snf /usr/share/zoneinfo/$Tz /etc/localtime
  echo $Tz >/etc/timezone
fi

# Essentials -------------------------------------------------------------------
echo '[-- INFO --] Installing Essential Packages...'
case $Os in
ubuntu)
  apt-get update
  apt-get install -y --no-install-recommends sudo git
  ;;
arch)
  pacman -Syu --noconfirm
  pacman -S --noconfirm --needed \
    sudo git
  ;;
esac

# Git --------------------------------------------------------------------------
echo '[-- INFO --] Git Configuration...'
git config --system http.sslVerify false
git config --system --add safe.directory "*"

# User -------------------------------------------------------------------------
echo '[-- INFO --] Setting up user...'
awk -F: '$3 >= 1000 && $3 < 60000 {print $1}' /etc/passwd | xargs -r -n1 userdel -r 2>/dev/null || true
useradd -m -s /bin/bash "$CONFIG_USER_NAME"
echo "$CONFIG_USER_NAME:$CONFIG_USER_NAME" | chpasswd
chown -R "$CONFIG_USER_NAME:$CONFIG_USER_NAME" "/home/$CONFIG_USER_NAME"
chmod g+s "/home/$CONFIG_USER_NAME"
echo "$CONFIG_USER_NAME ALL=(ALL) NOPASSWD:ALL" >"/etc/sudoers.d/$CONFIG_USER_NAME"

if ! getent group render >/dev/null 2>&1; then
  groupadd -g 990 -o render
  usermod -aG video "$CONFIG_USER_NAME"
  usermod -aG render "$CONFIG_USER_NAME"
fi

echo "[-- DONE --] ${BASH_SOURCE[0]}"
