# QEMU VirtIO-FS File Sharing (fshare)

Hướng dẫn chia sẻ thư mục tốc độ cao giữa máy Host Linux và máy ảo Windows qua VirtIO-FS.

---

## 1. Khởi động chia sẻ trên máy Host

Chỉ định thư mục bạn muốn chia sẻ với máy ảo:

```bash
skj qemu/fshare-on <đường_dẫn_thư_mục>
```

*Ví dụ:*

```bash
# Chia sẻ thư mục hiện tại:
skj qemu/fshare-on .

# Hoặc chia sẻ một thư mục cụ thể:
skj qemu/fshare-on /path/to/folder
```

---

## 2. Khởi chạy máy ảo QEMU

Khởi chạy máy ảo với thêm cờ `--fshare`:

```bash
skj qemu/run --windows --fshare windows.qcow2
```

> [!NOTE]
> Cờ `--fshare` sẽ tự động:
>
> - Cấu hình bộ nhớ chia sẻ (`share=on`) cho vhost-user.
> - Kết nối với tiến trình `virtiofsd` qua socket `/tmp/virtiofsd.sock`.
> - Tự động gắn đĩa driver `virtio-win.iso` để Windows có sẵn driver cần thiết.
> - Tự động khôi phục / khởi động lại `virtiofsd` nếu máy ảo trước đó vừa tắt.

---

## 3. Cấu hình bên trong máy ảo Windows

Để thư mục chia sẻ xuất hiện thành ổ đĩa trong **This PC**, thực hiện các bước sau (chỉ cần làm lần đầu tiên):

### Bước 3.1: Cài đặt VirtIO Guest Tools

Nếu chưa cài driver VirtIO, mở ổ đĩa CD `virtio-win` và chạy:

```text
D:\virtio-win-guest-tools.exe
```

### Bước 3.2: Tải và cài đặt WinFsp

VirtIO-FS trên Windows bắt buộc cần có thư viện **WinFsp** làm cầu nối filesystem:

- Tải file cài đặt `.msi` từ trang chủ: [https://winfsp.dev/](https://winfsp.dev/)
- Hoặc từ GitHub Releases: [https://github.com/winfsp/winfsp/releases](https://github.com/winfsp/winfsp/releases)
- Chạy cài đặt file `.msi` theo mặc định (khoảng 10 giây).

### Bước 3.3: Kích hoạt dịch vụ VirtIO-FS Service

Mở **Command Prompt (CMD)** với quyền **Administrator** và chạy:

```cmd
sc config VirtioFsSvc start= auto
sc start VirtioFsSvc
```

👉 Ngay sau khi lệnh chạy thành công, mở **This PC** sẽ thấy ổ đĩa chia sẻ xuất hiện (thường là ổ **`Z:`** với nhãn `fshare`), có thể đọc/ghi 2 chiều trực tiếp với máy Host.

---

## 4. Tắt chia sẻ trên máy Host

Khi không còn nhu cầu chia sẻ thư mục:

```bash
skj qemu/fshare-off
```

Lệnh này sẽ tắt tiến trình `virtiofsd` và dọn dẹp toàn bộ file socket tạm thời.
