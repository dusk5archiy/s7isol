# Create Partitions

```bash
skj qemu/run --windows winpe.iso disk.qcow2 windows-installer.iso
```

Hit `shift + F10` and type:

```cmd
diskpart
```

Using `diskpart`

```cmd
select disk 0
clean
convert gpt
create partition efi size=1024
format fs=fat32 quick
assign letter=S
create partition primary
format fs=ntfs quick
assign letter=V
```

- `1024`: 1024 MB
- `E`: Windows Installer ISO

```cmd
dism /apply-image /imagefile:"E:\sources\install.wim"" /index:1 /applydir:V:\
bcdboot V:\Windows /s S: /f uefi
```

Then (first boot must not run with `--virtio`)

```bash
skj qemu/run --windows disk.qcow2
```

Start (`SHIFT + F10`)

```cmd
start ms-cxh:localonly
```

Enable Virtio

```bash
skj qemu/run --windows disk.qcow2 --dummy dummy.qcow2
# Device Manager -> Install virtio from D:\
```

Probably you can install drivers via `D:\virtio-win-guest-tools.exe`.

```cmd
bcdedit /set {default} hypervisorlaunchtype off
```
