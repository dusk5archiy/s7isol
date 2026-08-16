#!/bin/bash
set -euo pipefail

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

echo $(get_country_code 2>/dev/null || true)
