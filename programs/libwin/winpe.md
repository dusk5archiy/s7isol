# Building a Dual UEFI/BIOS Lightweight WinPE ISO with `xorriso`

<!--toc:start-->
- [Building a Dual UEFI/BIOS Lightweight WinPE ISO with `xorriso`](#building-a-dual-uefibios-lightweight-winpe-iso-with-xorriso)
  - [Complete Command](#complete-command)
  - [Detailed Parameter Breakdown](#detailed-parameter-breakdown)
    - [Core Environment Flags](#core-environment-flags)
    - [Legacy BIOS Boot Section](#legacy-bios-boot-section)
    - [UEFI Boot Section](#uefi-boot-section)
    - [Hybrid Partitioning and Exclusions](#hybrid-partitioning-and-exclusions)
    - [Output and Input Targets](#output-and-input-targets)
<!--toc:end-->

This document details the exact parameters used to construct a bootable Windows
PE ISO from a mounted Windows installation media while excluding the large
installation payload (`install.wim` / `install.esd`).

---

## Complete Command

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

---

## Detailed Parameter Breakdown

### Core Environment Flags

| Parameter | Purpose |
| :--- | :--- |
| `-as mkisofs` | Directs `xorriso` to emulate `mkisofs` / `genisoimage` command-line syntax. |
| `-iso-level 3` | Sets ISO 9660 compliance to Level 3, enabling support for large files (>4 GB) and longer directory structures. |
| `-full-iso9660-filenames` | Permits filenames up to 31 characters on the ISO 9660 filesystem layer without requiring Rock Ridge extensions. |
| `-volid "WINPE"` | Sets the volume identifier (label) of the generated optical media to `WINPE`. |

---

### Legacy BIOS Boot Section

These flags define the primary El Torito boot entry targeted at legacy x86 BIOS firmwares:

| Parameter | Purpose |
| :--- | :--- |
| `-b "boot/etfsboot.com"` | Specifies the legacy BIOS boot loader binary relative to the root of the source media. |
| `-no-emul-boot` | Instructs BIOS firmware to execute `etfsboot.com` directly without floppy or hard disk emulation. |
| `-boot-load-size 8` | Configures the initial virtual sector load size to 8 (512-byte blocks, total 4 KiB) for `etfsboot.com` execution. |

---

### UEFI Boot Section

These flags declare a secondary El Torito entry specifically structured for UEFI firmwares (such as QEMU OVMF):

| Parameter | Purpose |
| :--- | :--- |
| `-eltorito-alt-boot` | Closes the BIOS boot catalog entry and begins a new El Torito boot section. |
| `-e "efi/microsoft/boot/efisys.bin"` | Points to the UEFI boot image. `efisys.bin` is a raw FAT filesystem image containing `\EFI\Boot\bootx64.efi`. |
| `-no-emul-boot` | Instructs UEFI firmware to process `efisys.bin` directly as an EFI System Partition. |

---

### Hybrid Partitioning and Exclusions

| Parameter | Purpose |
| :--- | :--- |
| `-isohybrid-gpt-basdat` | Maps the FAT partition image (`efisys.bin`) into a GPT table as a Basic Data / EFI partition, allowing OVMF and physical UEFI machines to discover the boot partition. |
| `-m "*install.wim*"` | Filters out the primary Windows installation WIM payload. |
| `-m "*install.esd*"` | Filters out compressed ESD installation files. |
| `-m "*install*.swm"` | Filters out split WIM image archives. |

---

### Output and Input Targets

| Parameter | Purpose |
| :--- | :--- |
| `-output "$OutputIso"` | Specifies the target output path for the constructed `.iso` image file. |
| `"$WinimgMountMedia"` | The source directory (e.g., loopback mount point of the original Windows ISO) from which files are read directly. |
