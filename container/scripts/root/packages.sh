#!/bin/bash

set -euo pipefail

TZ=Etc/UTC

case "$(source /etc/os-release && echo $ID)" in
ubuntu)
  echo "[-- Detecting closest APT mirror --]"

  # Function to query IP location using pure Bash /dev/tcp
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

  # Fallback check: if valid 2-letter code, replace mirror URL
  if [[ -n "$COUNTRY_CODE" && ${#COUNTRY_CODE} -eq 2 ]]; then
    REGIONAL_MIRROR="${COUNTRY_CODE}.archive.ubuntu.com"
    echo "[-- Attempting switch to: ${REGIONAL_MIRROR} --]"
    if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then
      sed -i "s|http://archive.ubuntu.com/ubuntu/|http://${REGIONAL_MIRROR}/ubuntu/|g" /etc/apt/sources.list.d/ubuntu.sources
    fi
  fi

  apt-get update

  # ca-certificates: required for git clone
  apt-get install -y --no-install-recommends \
    sudo \
    git \
    ca-certificates \
    tzdata

  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
  echo $TZ >/etc/timezone
  dpkg-reconfigure --frontend noninteractive tzdata

  git config --global http.sslVerify false
  ;;
*)
  echo "[-- unsupported platform --]" >&2
  exit 1
  ;;
esac
