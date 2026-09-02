#!/bin/bash
set -euo pipefail

show_help() {
  cat <<EOF
Usage: $S7ISOL_TARGET <file1> [file2 ...] [OPTIONS]

Run a QEMU x86_64 virtual machine with auto-detected media files.

Arguments:
  <file...>       List of image files (.iso, .qcow2, .img, .raw, etc.)
                  - ISO files (.iso) attach as CD-ROM boot drives.
                  - Disk files (.qcow2, .img, .raw) attach as virtual hard disks.

Options:
  -h, --help      Show this help message and exit.

Examples:
  # Boot ISO only:
  $S7ISOL_TARGET ubuntu.iso

  # Attach a disk image and an ISO (order does not matter):
  $S7ISOL_TARGET disk.qcow2 ubuntu.iso
EOF
}

# Check for help flag or missing arguments
if [[ $# -eq 0 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  show_help
  exit 0
fi

QemuArgs=(
  -accel kvm
  -cpu host
  -m 6G
  -smp 6
  -usb -device usb-mouse -device usb-kbd
  -display "gtk,zoom-to-fit=on"
)

HasCdrom=false

# Loop through all provided file arguments
for file in "$@"; do
  if [[ ! -f "$file" ]]; then
    echo "[-- error --] specified file does not exist: $file" >&2
    exit 1
  fi

  case "$file" in
  *.iso)
    QemuArgs+=(-cdrom "$file")
    HasCdrom=true
    ;;
  *.qcow2)
    QemuArgs+=(-drive "file=$file,format=qcow2")
    ;;
  *.img | *.raw)
    QemuArgs+=(-drive "file=$file,format=raw")
    ;;
  *)
    # Fallback for unrecognized disk extensions
    QemuArgs+=(-drive "file=$file,format=raw")
    ;;
  esac
done

# Set boot order to CD-ROM if an ISO was attached
if [[ "$HasCdrom" == true ]]; then
  QemuArgs+=(-boot d)
fi

sudo qemu-system-x86_64 "${QemuArgs[@]}"
