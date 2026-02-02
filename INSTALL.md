# Hướng Dẫn Cài Đặt - Installation Guide

## Yêu Cầu

- NixOS đã được cài đặt
- Quyền sudo
- Kết nối internet

## Cài Đặt Nhanh

### 1. Clone repository

```bash
git clone https://github.com/your-username/river-dotfiles.git
cd river-dotfiles
```

### 2. Chạy script cài đặt

```bash
chmod +x install.sh
./install.sh
```

Script sẽ hỏi bạn:
- **Username**: Tên người dùng của bạn
- **Hostname**: Tên máy tính
- **Full Name**: Tên đầy đủ (cho Git)
- **Email**: Email của bạn (cho Git)

### 3. Build hệ thống

```bash
sudo nixos-rebuild switch --flake .#river
```

### 4. Reboot

```bash
reboot
```

## Sau Khi Cài Đặt

### Đổi Password

Password mặc định là `changeme`. Hãy đổi ngay:

```bash
passwd
```

### Thử Wallpaper System

```bash
# Chuyển ảnh nền ngẫu nhiên
wallpaper-manager random

# Hoặc dùng phím tắt
Mod+Alt+W
```

### Xem Tài Liệu

```bash
cat WALLPAPER_SETUP.md    # Hướng dẫn nhanh
cat wallpapers/README.md  # Tài liệu đầy đủ
```

## Cài Đặt Thủ Công (Không dùng script)

### 1. Tạo hardware config

```bash
sudo nixos-generate-config --show-hardware-config > hosts/default/hardware-configuration.nix
```

### 2. Chỉnh sửa config files

**hosts/default/configuration.nix:**
- Đổi `networking.hostName`
- Đổi `users.users.will` thành username của bạn

**hosts/default/home.nix:**
- Đổi `home.username`
- Đổi `home.homeDirectory`

**flake.nix:**
- Đổi `home-manager.users.will` thành username của bạn

**modules/home/git.nix:**
- Đổi `name` và `email`

**modules/desktop/greetd.nix:**
- Đổi `user = "will"` thành username của bạn

### 3. Build

```bash
sudo nixos-rebuild switch --flake .#river
```

## Tùy Chỉnh

### Thêm Wallpapers

```bash
cp your-images.jpg wallpapers/
sudo nixos-rebuild switch --flake .#river
```

### Thay Đổi Timezone

Sửa trong `hosts/default/configuration.nix`:

```nix
time.timeZone = "Asia/Ho_Chi_Minh";  # Đổi thành timezone của bạn
```

### Cấu Hình Niri

Chỉnh sửa `config/niri/config.kdl` để tùy chỉnh:
- Phím tắt
- Layout
- Animations

## Xử Lý Lỗi

### Lỗi: "flake evaluation failed"

Đảm bảo bạn đã enable flakes:

```bash
sudo nixos-rebuild switch --flake .#river --impure
```

### Lỗi: "user 'will' not found"

Bạn chưa cập nhật username trong config files. Chạy lại `install.sh` hoặc chỉnh sửa thủ công.

### Lỗi: "hardware-configuration.nix not found"

Tạo file hardware config:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/default/hardware-configuration.nix
```

## Tính Năng

✨ **Desktop Environment**
- Niri (Wayland compositor)
- Noctalia Shell
- Beautiful GTK theme

🎨 **Wallpaper System**
- Auto-change every 30 minutes
- 5+ transition effects
- Beautiful login screen
- Keyboard shortcuts

🛠️ **Development Tools**
- Helix editor
- Git
- Docker
- Development packages

## Gỡ Bỏ

Nếu muốn quay về config cũ:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

## Hỗ Trợ

- **Tài liệu**: Xem các file .md trong repo
- **Issues**: Mở issue trên GitHub
- **Wallpaper help**: `wallpaper-manager help`

## Credits

- **Niri**: https://github.com/YaLTeR/niri
- **Noctalia Shell**: https://github.com/noctalia-dev/noctalia-shell
- **Wallpapers**: Neytirix, PikaOS, Pexels

---

**Chúc bạn có trải nghiệm NixOS tuyệt vời! 🚀**