# Wallpaper System - Hệ thống Quản lý Ảnh nền 🎨

## Tổng quan

Hệ thống tự động quản lý và thay đổi ảnh nền cho môi trường Niri với hiệu ứng đẹp mắt. Sau khi chạy `nixos-rebuild`, tất cả ảnh trong thư mục này sẽ được tự động copy vào `~/Pictures/Wallpapers` và hệ thống sẽ tự động chuyển đổi ảnh nền với các hiệu ứng transition mượt mà.

## Tính năng ✨

- ✅ Tự động copy ảnh nền sau khi rebuild
- ✅ Tự động chuyển ảnh nền ngẫu nhiên mỗi 30 phút
- ✅ Hiệu ứng transition đẹp mắt (fade, wipe, grow, outer, wave)
- ✅ Script quản lý wallpaper thủ công với nhiều tùy chọn
- ✅ Màn hình login đẹp với wallpaper tùy chỉnh
- ✅ Hỗ trợ định dạng: JPG, JPEG, PNG
- ✅ Sử dụng **swww** - công cụ wallpaper hiện đại cho Wayland

## Cài đặt 🚀

Sau khi thêm ảnh vào thư mục này, chạy:

```bash
sudo nixos-rebuild switch --flake .#river
```

Hệ thống sẽ tự động:
1. Copy tất cả ảnh vào `~/Pictures/Wallpapers`
2. Copy một ảnh ngẫu nhiên cho màn hình login
3. Khởi động swww daemon
4. Khởi động service tự động chuyển ảnh nền
5. Đặt ảnh nền ngẫu nhiên ban đầu với hiệu ứng đẹp

## Sử dụng 💻

### Quản lý Service

```bash
# Xem trạng thái service
systemctl --user status wallpaper-changer

# Khởi động service
systemctl --user start wallpaper-changer

# Dừng service
systemctl --user stop wallpaper-changer

# Khởi động lại service
systemctl --user restart wallpaper-changer

# Xem log
journalctl --user -u wallpaper-changer -f
```

### Quản lý Ảnh nền Desktop 🖼️

```bash
# Chọn ảnh nền ngẫu nhiên
wallpaper-manager random

# Chọn ngẫu nhiên với hiệu ứng cụ thể
SWWW_TRANSITION=grow wallpaper-manager random

# Chuyển sang ảnh tiếp theo
wallpaper-manager next

# Quay lại ảnh trước
wallpaper-manager prev

# Đặt ảnh nền cụ thể
wallpaper-manager set ~/Pictures/Wallpapers/my-favorite.jpg

# Đặt ảnh với hiệu ứng đẹp
SWWW_TRANSITION=grow SWWW_DURATION=3 wallpaper-manager set ~/path/to/image.jpg

# Xem ảnh nền hiện tại
wallpaper-manager current

# Liệt kê tất cả ảnh có sẵn
wallpaper-manager list

# Khởi tạo swww daemon (nếu cần)
wallpaper-manager init

# Xem trợ giúp
wallpaper-manager help
```

### Quản lý Ảnh nền Login Screen 🔐

```bash
# Setup wallpaper ngẫu nhiên cho login screen
sudo login-wallpaper setup

# Setup wallpaper cụ thể cho login screen
sudo login-wallpaper setup ~/Pictures/Wallpapers/my-login-bg.jpg

# Xem wallpaper hiện tại của login screen
login-wallpaper current

# Xem trợ giúp
login-wallpaper help
```

### Hiệu ứng Transition có sẵn 🎭

Sử dụng biến môi trường `SWWW_TRANSITION` để chọn hiệu ứng:

- **fade** - Mờ dần (mặc định)
- **wipe** - Quét ngang/dọc
- **grow** - Phóng to từ trung tâm
- **outer** - Phóng to từ góc
- **wave** - Sóng lan tỏa
- **random** - Ngẫu nhiên mỗi lần

Ví dụ:
```bash
# Hiệu ứng grow với thời gian 3 giây
SWWW_TRANSITION=grow SWWW_DURATION=3 wallpaper-manager random

# Hiệu ứng wave
SWWW_TRANSITION=wave wallpaper-manager next
```

### Phím tắt (Thêm vào Niri config) ⌨️

Thêm vào `~/.config/niri/config.kdl`:

```kdl
binds {
    // Chuyển ảnh nền ngẫu nhiên
    Mod+Alt+W { spawn "wallpaper-manager" "random"; }
    
    // Ảnh tiếp theo
    Mod+Alt+N { spawn "wallpaper-manager" "next"; }
    
    // Ảnh trước đó
    Mod+Alt+P { spawn "wallpaper-manager" "prev"; }
    
    // Chuyển ảnh với hiệu ứng grow
    Mod+Alt+G { spawn-sh "SWWW_TRANSITION=grow wallpaper-manager random"; }
}
```

## Tùy chỉnh ⚙️

### Thay đổi thời gian tự động chuyển ảnh

Sửa file `hosts/default/home.nix`, tìm dòng:

```nix
INTERVAL=1800  # Đổi ảnh mỗi 30 phút (1800 giây)
```

Thay đổi giá trị (tính bằng giây):
- `600` = 10 phút
- `1800` = 30 phút (mặc định)
- `3600` = 1 giờ
- `7200` = 2 giờ

Sau đó rebuild:

```bash
sudo nixos-rebuild switch --flake .#river
```

### Thay đổi hiệu ứng mặc định

Trong file `hosts/default/home.nix`, sửa phần:

```nix
TRANSITIONS=("fade" "wipe" "grow" "outer" "wave")
```

Xóa bỏ các hiệu ứng không muốn hoặc chỉ giữ lại một hiệu ứng yêu thích.

### Tắt tự động chuyển ảnh nền

```bash
systemctl --user disable --now wallpaper-changer
```

### Bật lại tự động chuyển ảnh nền

```bash
systemctl --user enable --now wallpaper-changer
```

### Tùy chỉnh màn hình login

Sửa file `modules/desktop/greetd.nix` để thay đổi:
- Thông điệp chào mừng
- Theme và màu sắc
- Font chữ
- Icon theme

Hoặc sửa file CSS: `config/regreet/style.css` để tùy chỉnh giao diện chi tiết.

## Thêm ảnh mới 📥

### Cách 1: Rebuild (khuyến nghị)

1. Copy ảnh vào thư mục này (`wallpapers/`)
2. Chạy rebuild:
   ```bash
   sudo nixos-rebuild switch --flake .#river
   ```

### Cách 2: Copy thủ công

```bash
# Copy ảnh vào thư mục wallpapers của user
cp your-image.jpg ~/Pictures/Wallpapers/

# Đặt luôn làm ảnh nền
wallpaper-manager set ~/Pictures/Wallpapers/your-image.jpg

# Setup cho login screen (nếu muốn)
sudo login-wallpaper setup ~/Pictures/Wallpapers/your-image.jpg
```

## Xử lý sự cố 🔧

### Service không chạy

```bash
# Xem log chi tiết
journalctl --user -u wallpaper-changer -f

# Khởi động lại service
systemctl --user restart wallpaper-changer

# Kiểm tra swww daemon
pgrep swww-daemon

# Khởi động lại swww
pkill swww-daemon
wallpaper-manager init
```

### Ảnh nền không thay đổi

```bash
# Kiểm tra ảnh có trong thư mục
ls ~/Pictures/Wallpapers/

# Kiểm tra quyền truy cập
ls -la ~/Pictures/Wallpapers/

# Thử đặt ảnh thủ công
wallpaper-manager random

# Xem log
journalctl --user -u wallpaper-changer -n 50
```

### Login screen không hiển thị wallpaper

```bash
# Kiểm tra wallpaper trong /var/lib/greetd
sudo ls -la /var/lib/greetd/

# Setup lại wallpaper cho login
sudo login-wallpaper setup

# Kiểm tra quyền truy cập
sudo chown greeter:greeter /var/lib/greetd/wallpaper*
sudo chmod 644 /var/lib/greetd/wallpaper.*
```

### Kill tất cả swww processes

```bash
pkill swww
pkill swww-daemon
wallpaper-manager init
wallpaper-manager random
```

### Hiệu ứng bị lag hoặc giật

```bash
# Giảm thời gian transition
SWWW_DURATION=1 wallpaper-manager random

# Sử dụng hiệu ứng đơn giản hơn
SWWW_TRANSITION=fade wallpaper-manager random

# Kiểm tra tài nguyên hệ thống
htop
```

## Cấu trúc File 📁

```
river-dotfiles/
├── wallpapers/              # Thư mục chứa ảnh nền
│   ├── README.md           # File này
│   └── *.jpg, *.png        # Các file ảnh
├── scripts/
│   ├── wallpaper-manager.sh    # Script quản lý wallpaper
│   └── login-wallpaper.sh      # Script quản lý login wallpaper
├── config/
│   └── regreet/
│       └── style.css       # CSS tùy chỉnh cho login screen
└── modules/
    └── desktop/
        └── greetd.nix      # Cấu hình login screen
```

## Kỹ thuật 🛠️

- **Backend**: swww (Efficient animated wallpaper daemon for Wayland)
- **Tự động hóa**: systemd user service
- **Copy files**: Home Manager activation scripts
- **Quản lý**: Bash scripts với nhiều tính năng
- **Login**: ReGreet (GTK-based greeter) với CSS tùy chỉnh
- **Compositor**: cage (minimal Wayland compositor cho login)

## Ưu điểm của swww so với swaybg 🌟

1. **Hiệu ứng transition mượt mà** - Chuyển ảnh không bị giật
2. **Nhiều hiệu ứng** - fade, wipe, grow, outer, wave
3. **Hiệu suất tốt** - Tối ưu cho Wayland
4. **Dễ dùng** - CLI đơn giản, dễ script
5. **Animated wallpapers** - Hỗ trợ GIF (nếu cần)

## Tips & Tricks 💡

### Tạo slideshow với hiệu ứng khác nhau

```bash
while true; do
  EFFECTS=("fade" "wipe" "grow" "outer" "wave")
  RANDOM_EFFECT=${EFFECTS[$RANDOM % ${#EFFECTS[@]}]}
  SWWW_TRANSITION=$RANDOM_EFFECT wallpaper-manager random
  sleep 1800  # 30 phút
done
```

### Đặt ảnh nền theo thời gian trong ngày

Tạo script:

```bash
#!/bin/bash
HOUR=$(date +%H)

if [ $HOUR -ge 6 ] && [ $HOUR -lt 12 ]; then
  # Sáng - ảnh sáng sủa
  wallpaper-manager set ~/Pictures/Wallpapers/morning.jpg
elif [ $HOUR -ge 12 ] && [ $HOUR -lt 18 ]; then
  # Chiều - ảnh ban ngày
  wallpaper-manager set ~/Pictures/Wallpapers/afternoon.jpg
else
  # Tối - ảnh tối màu
  wallpaper-manager set ~/Pictures/Wallpapers/night.jpg
fi
```

### Chọn ảnh theo màu chủ đạo

```bash
# Ảnh tối cho ban đêm
find ~/Pictures/Wallpapers -name "*dark*" -o -name "*night*" | shuf -n 1 | xargs wallpaper-manager set

# Ảnh sáng cho ban ngày
find ~/Pictures/Wallpapers -name "*light*" -o -name "*day*" | shuf -n 1 | xargs wallpaper-manager set
```

## Performance 📊

- **RAM usage**: ~5-10MB (swww daemon)
- **CPU usage**: <1% khi idle, 5-15% khi transition
- **Startup time**: <1 giây
- **Transition time**: 1-3 giây (tùy chỉnh được)

## Credits 🎨

Bộ sưu tập ảnh nền chủ yếu từ:
- **Neytirix** - Nghệ sĩ digital art tài năng
- **PikaOS** - Wallpaper chính thức
- **Pexels** - Free stock photos
- Các nguồn khác

## Tài liệu tham khảo 📚

- [swww GitHub](https://github.com/Horus645/swww)
- [ReGreet Documentation](https://github.com/rharish101/ReGreet)
- [Niri Wiki](https://github.com/YaLTeR/niri/wiki)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)

---

**Enjoy your beautiful wallpapers! 🌈✨**