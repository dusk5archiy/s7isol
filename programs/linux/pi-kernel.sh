#!/bin/bash
set -euo pipefail

# ==========================================
# CONFIGURATION
# ==========================================
BuildDir=$HOME/rpi-kernel-build
OutputDir=$BuildDir/output
Jobs=$(nproc)

# Choose your QEMU machine type:
# "virt"    -> Fast development VM with VirtIO/PCI virtualization (highly recommended)
# "raspi4b" -> Strict, bare-metal hardware emulation of the physical SoC (No VirtIO/PCI)
VmType="virt"

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
  git clone --depth=1 https://github.com
else
  echo "==> Kernel source already exists, skipping clone..."
fi

cd linux

echo "==> Step 3: Generating baseline Pi 4 configuration (bcm2711_defconfig)..."
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make bcm2711_defconfig

# ==========================================
# Step 3.5: Apply Driver Configurations
# ==========================================
if [ "$VmType" = "virt" ]; then
  echo "==> Target is QEMU -M virt: Applying KVM/VirtIO base fragments..."
  # Replaces manual VirtIO, block device, and network infrastructure configs
  ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make kvm_guest.config

  echo "==> Enabling supporting PCI, Display & USB Peripheral Drivers..."
  # Enable PCI & Generic Host Bridge Subsystems
  ./scripts/config --enable CONFIG_PCI
  ./scripts/config --enable CONFIG_PCI_DOMAINS
  ./scripts/config --enable CONFIG_PCI_DOMAINS_GENERIC
  ./scripts/config --enable CONFIG_PCI_HOST_GENERIC

  # Enable DRM, Framebuffer & VirtIO Graphics
  ./scripts/config --enable CONFIG_DRM
  ./scripts/config --enable CONFIG_DRM_VIRTIO_GPU
  ./scripts/config --enable CONFIG_FB
  ./scripts/config --enable CONFIG_FB_SIMPLE
  ./scripts/config --enable CONFIG_FRAMEBUFFER_CONSOLE
  ./scripts/config --enable CONFIG_VT
  ./scripts/config --enable CONFIG_VT_CONSOLE

  # Enable USB Subsystem & XHCI Controller (Required for qemu-xhci)
  ./scripts/config --enable CONFIG_USB
  ./scripts/config --enable CONFIG_USB_SUPPORT
  ./scripts/config --enable CONFIG_USB_XHCI_HCD
  ./scripts/config --enable CONFIG_USB_XHCI_PCI

  # Enable USB Input & Human Interface Devices (Modern Framework)
  ./scripts/config --enable CONFIG_INPUT
  ./scripts/config --enable CONFIG_INPUT_KEYBOARD
  ./scripts/config --enable CONFIG_INPUT_MOUSE
  ./scripts/config --enable CONFIG_HID
  ./scripts/config --enable CONFIG_USB_HID

else
  echo "==> Target is QEMU -M raspi4b: Enforcing physical SoC Broadcom configurations..."
  ./scripts/config --enable CONFIG_USB_XHCI_HCD
  ./scripts/config --enable CONFIG_DRM_V3D
  ./scripts/config --enable CONFIG_FB_BCM2708
fi

# Filesystems & Devtmpfs Mount Support
./scripts/config --enable CONFIG_EXT4_FS
./scripts/config --enable CONFIG_DEVTMPFS
./scripts/config --enable CONFIG_DEVTMPFS_MOUNT

# Enable ZRAM & Compressed Swap Subsystems
./scripts/config --enable CONFIG_ZRAM
./scripts/config --set-str CONFIG_ZRAM_DEF_COMP "lz4"
./scripts/config --enable CONFIG_CRYPTO_LZ4
./scripts/config --enable CONFIG_SWAP

# Core GPIO Framework
./scripts/config --enable CONFIG_GPIOLIB
./scripts/config --enable CONFIG_GPIO_CDEV

# ConfigFS (Required for modern gpio-sim module)
./scripts/config --enable CONFIG_CONFIGFS_FS

# Enable Modern GPIO Simulator (Linux 5.19+) and Legacy Mockup
./scripts/config --enable CONFIG_GPIO_SIM
./scripts/config --enable CONFIG_GPIO_MOCKUP

# DebugFS for inspecting /sys/kernel/debug/gpio
./scripts/config --enable CONFIG_DEBUG_FS

# Resolve configuration dependencies automatically
echo "==> Cleaning up dependency alignments..."
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make olddefconfig

# ==========================================
# Step 4: Compilation
# ==========================================
echo "==> Step 4: Compiling Kernel, Modules, and DTBs using $Jobs threads..."
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make -j"$Jobs" Image modules dtbs

# ==========================================
# Step 5: Artifact Collection
# ==========================================
echo "==> Step 5: Collecting output artifacts..."
mkdir -p "$OutputDir"

# Copy Kernel Image
cp arch/arm64/boot/Image "$OutputDir/Image"

# Copy Pi 4 Device Tree Blob
cp arch/arm64/boot/dts/broadcom/bcm2711-rpi-4-b.dtb "$OutputDir/rpi.dtb"

echo "========================================================="
echo "  BUILD SUCCESSFUL!"
echo "  Target Architecture Mode: QEMU -M $VmType"
echo "  Kernel saved to: $OutputDir/Image"
echo "========================================================="

# Standard terminal alert bell upon completion
cleanup() {
  kill $PID 2>/dev/null
  exit
}
trap cleanup INT TERM EXIT

(while true; do
  echo -ne "\a"
  sleep 0.5
done) &
PID=$!
read -r
kill $PID 2>/dev/null
