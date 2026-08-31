#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 <VendorID:ProductID>"
  exit 1
fi

IFS=':' read -r vendor product <<<"$1"
Vendor=$(echo "$vendor" | tr '[:upper:]' '[:lower:]' | xargs)
Product=$(echo "$product" | tr '[:upper:]' '[:lower:]' | xargs)
usb-devices | awk -v RS= "/Vendor=$Vendor/ && /ProdID=$Product/"
