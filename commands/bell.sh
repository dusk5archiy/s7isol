#!/bin/bash
set -euo pipefail

cleanup() {
  kill "$PID" 2>/dev/null
  exit
}
trap cleanup INT TERM EXIT

(
  while true; do
    echo -ne "\a"
    sleep 0.5
  done
) &
PID=$!

read -r

kill "$PID" 2>/dev/null
