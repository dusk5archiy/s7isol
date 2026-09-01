#!/bin/bash
set -euo pipefail

# Configuration
BuildDir=$HOME/rpi-kernel-build
OutputDir=$BuildDir/output
Jobs=$(nproc)

echo "==> Step 1: Installing Arch Linux dependencies & ARM64 toolchain..."
sudo pacman -S --needed --noconfirm \
  base-devel \
  aarch64-linux-gnu-gcc \
  aarch64-linux-gnu-binutils \
  aarch64-linux-gnu-glibc \
  bison \
  flex \
  openssl \
  libelf \
  bc \
  git \
  kmod \
  dtc \
  cpio

echo "==> Step 2: Preparing build environment..."
mkdir -p "$BuildDir"
cd "$BuildDir"

if [[ ! -d linux ]]; then
  echo "==> Cloning default branch of official Raspberry Pi Linux repo..."
  git clone --depth=1 https://github.com/raspberrypi/linux.git
else
  echo "==> Kernel source already exists, skipping clone..."
fi

cd linux

echo "==> Step 3: Generating baseline Pi 4 configuration (bcm2711_defconfig)..."
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make bcm2711_defconfig

echo "==> Step 3.5: Force-enabling PCI Bus & VirtIO Drivers..."

# Enable PCI & Generic Host Bridge Subsystems
./scripts/config --enable CONFIG_PCI
./scripts/config --enable CONFIG_PCI_DOMAINS
./scripts/config --enable CONFIG_PCI_DOMAINS_GENERIC
./scripts/config --enable CONFIG_PCI_HOST_GENERIC

# Enable Core VirtIO Architecture & Bus Drivers
./scripts/config --enable CONFIG_VIRTIO
./scripts/config --enable CONFIG_VIRTIO_MENU
./scripts/config --enable CONFIG_VIRTIO_PCI
./scripts/config --enable CONFIG_VIRTIO_MMIO

# Enable VirtIO Block Device & Storage Dependencies
./scripts/config --enable CONFIG_BLOCK
./scripts/config --enable CONFIG_BLK_DEV
./scripts/config --enable CONFIG_VIRTIO_BLK

# Enable VirtIO Network Device & Net Core Dependencies
./scripts/config --enable CONFIG_NETDEVICES
./scripts/config --enable CONFIG_NET_CORE
./scripts/config --enable CONFIG_VIRTIO_NET

# Filesystems & Devtmpfs Mount Support
./scripts/config --enable CONFIG_EXT4_FS
./scripts/config --enable CONFIG_DEVTMPFS
./scripts/config --enable CONFIG_DEVTMPFS_MOUNT

# Resolve configuration dependencies automatically
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make olddefconfig

echo "==> Step 4: Compiling Kernel, Modules, and DTBs using $Jobs threads..."
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make -j"$Jobs" Image modules dtbs

echo "==> Step 5: Collecting output artifacts..."
mkdir -p "$OutputDir"

# Copy Kernel Image
cp arch/arm64/boot/Image "$OutputDir/Image"

# Copy Pi 4 Device Tree Blob
cp arch/arm64/boot/dts/broadcom/bcm2711-rpi-4-b.dtb "$OutputDir/rpi.dtb"

echo "========================================================="
echo "  BUILD SUCCESSFUL!"
echo "  VirtIO-enabled Kernel saved to: $OutputDir/Image"
echo "========================================================="

# Ring bell upon completion
skj bells
