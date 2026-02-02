# 🎨 Hướng Dẫn Nhanh - Wallpaper System

## Sau khi Rebuild

Sau khi chạy `sudo nixos-rebuild switch --flake .#river`, hệ thống đã tự động:

✅ Copy tất cả wallpapers vào `~/Pictures/Wallpapers`  
✅ Setup wallpaper cho màn hình login  
✅ Khởi động service tự động chuyển ảnh nền  
✅ Đặt ảnh nền ngẫu nhiên với hiệu ứng đẹp  

---

## 🚀 Sử Dụng Ngay

### Phím tắt đã cấu hình sẵn

| Phím tắt | Chức năng |
|----------|-----------|
| `Mod+Alt+W` | Chọn ảnh nền ngẫu nhiên |
| `Mod+Alt+N` | Ảnh tiếp theo |
| `Mod+Alt+B` | Ảnh trước đó |
| `Mod+Alt+G` | Ảnh ngẫu nhiên với hiệu ứng Grow |

*Lưu ý: `Mod` = `Super` (phím Windows) trên TTY, `Alt` trên cửa sổ*

### Lệnh Terminal

```bash
# Chuyển ảnh ngẫu nhiên
wallpaper-manager random

# Xem ảnh hiện tại
wallpaper-manager current

# Liệt kê tất cả ảnh
wallpaper-manager list

# Ảnh tiếp theo/trước
wallpaper-manager next
wallpaper-manager prev
```

---

## 🎭 Hiệu Ứng Đẹp

```bash
# Hiệu ứng fade (mờ dần)
SWWW_TRANSITION=fade wallpaper-manager random

# Hiệu ứng grow (phóng to)
SWWW_TRANSITION=grow wallpaper-manager random

# Hiệu ứng wave (sóng)
SWWW_TRANSITION=wave wallpaper-manager random

# Hiệu ứng wipe (quét)
SWWW_TRANSITION=wipe wallpaper-manager random

# Hiệu ứng outer (từ góc)
SWWW_TRANSITION=outer wallpaper-manager random
```

---

## 🔐 Màn Hình Login

```bash
# Setup wallpaper ngẫu nhiên cho login
sudo login-wallpaper setup

# Chọn ảnh cụ thể cho login
sudo login-wallpaper setup ~/Pictures/Wallpapers/your-image.jpg

# Xem ảnh đang dùng
login-wallpaper current
```

---

## ⚙️ Quản Lý Service

```bash
# Xem trạng thái
systemctl --user status wallpaper-changer

# Dừng tự động chuyển ảnh
systemctl --user stop wallpaper-changer

# Bật lại
systemctl --user start wallpaper-changer

# Xem log
journalctl --user -u wallpaper-changer -f
```

---

## 📥 Thêm Ảnh Mới

### Cách 1: Thêm vào dotfiles rồi rebuild (khuyến nghị)

```bash
# Copy ảnh vào thư mục wallpapers
cp ~/Downloads/new-wallpaper.jpg ~/river-dotfiles/wallpapers/

# Rebuild
cd ~/river-dotfiles
sudo nixos-rebuild switch --flake .#river
```

### Cách 2: Copy trực tiếp

```bash
# Copy vào thư mục Pictures
cp ~/Downloads/new-wallpaper.jpg ~/Pictures/Wallpapers/

# Đặt luôn làm ảnh nền
wallpaper-manager set ~/Pictures/Wallpapers/new-wallpaper.jpg
```

---

## 🎨 Tùy Chỉnh

### Thay đổi thời gian tự động chuyển ảnh

Sửa file `hosts/default/home.nix`, tìm dòng:
```nix
INTERVAL=1800  # 1800 = 30 phút
```

Thay đổi giá trị:
- 600 = 10 phút
- 1800 = 30 phút
- 3600 = 1 giờ

### Chọn hiệu ứng yêu thích

Sửa file `hosts/default/home.nix`, tìm dòng:
```nix
TRANSITIONS=("fade" "wipe" "grow" "outer" "wave")
```

Giữ lại chỉ hiệu ứng bạn thích, ví dụ:
```nix
TRANSITIONS=("grow" "wave")
```

### Tùy chỉnh màn hình login

- **Giao diện**: Sửa `config/regreet/style.css`
- **Cấu hình**: Sửa `modules/desktop/greetd.nix`

---

## 🔧 Xử Lý Sự Cố

### Ảnh không đổi

```bash
# Restart service
systemctl --user restart wallpaper-changer

# Kiểm tra swww daemon
pgrep swww-daemon

# Nếu không chạy, khởi động lại
wallpaper-manager init
```

### Login screen không có ảnh

```bash
# Setup lại
sudo login-wallpaper setup

# Kiểm tra file
sudo ls -la /var/lib/greetd/
```

### Service bị lỗi

```bash
# Xem log chi tiết
journalctl --user -u wallpaper-changer -n 50

# Kill và restart
systemctl --user restart wallpaper-changer
```

---

## 📚 Chi Tiết Hơn

Xem file `wallpapers/README.md` để biết đầy đủ tính năng và hướng dẫn chi tiết.

---

## ✨ Tính Năng Nổi Bật

- 🎨 **5+ hiệu ứng transition** mượt mà
- 🔄 **Tự động chuyển ảnh** theo thời gian
- 🎯 **Phím tắt tiện lợi** đã cấu hình sẵn
- 🔐 **Login screen đẹp** với CSS tùy chỉnh
- 📱 **Dễ quản lý** với script đơn giản
- ⚡ **Hiệu suất cao** với swww

---

**Chúc bạn có trải nghiệm desktop đẹp mắt! 🌈**