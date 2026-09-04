#!/bin/bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <PathToWindowsIso> [OutputIsoPath]"
  echo "Example: $0 /path/to/windows.iso ./winpe.iso"
  exit 1
fi

WinIso=$(realpath "$1")
OutputIso=${2:-./winpe.iso}
WinimgMountMedia=/media/winimg

cleanup() {
  local exit_code=$?
  echo "[INFO] Cleaning up temporary mount points..."
  if mountpoint -q "$WinimgMountMedia"; then
    sudo umount "$WinimgMountMedia" || echo "[WARNING] Failed to unmount $WinimgMountMedia" >&2
  fi
  if [ $exit_code -ne 0 ]; then
    echo "[FAILURE] ISO creation failed with exit code $exit_code." >&2
  fi
}
trap cleanup EXIT

sudo mount --mkdir -o loop,ro "$WinIso" "$WinimgMountMedia"

xorriso -as mkisofs \
  -iso-level 3 \
  -full-iso9660-filenames \
  -volid "WINPE" \
  -b "boot/etfsboot.com" \
  -no-emul-boot \
  -boot-load-size 8 \
  -eltorito-alt-boot \
  -e "efi/microsoft/boot/efisys.bin" \
  -no-emul-boot \
  -isohybrid-gpt-basdat \
  -m "*install.wim*" \
  -m "*install.esd*" \
  -m "*install*.swm" \
  -output "$OutputIso" \
  "$WinimgMountMedia"

echo "[SUCCESS] Created UEFI/BIOS bootable ISO at $OutputIso"
