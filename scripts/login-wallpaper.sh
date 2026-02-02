#!/usr/bin/env bash

# Script để setup wallpaper cho login screen (greetd/regreet)
# Sẽ được chạy tự động sau khi rebuild

WALLPAPER_SOURCE_DIR="/home/will/Pictures/Wallpapers"
LOGIN_WALLPAPER_DIR="/var/lib/greetd"
LOGIN_WALLPAPER_LINK="$LOGIN_WALLPAPER_DIR/wallpaper"

setup_login_wallpaper() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Setup Login Screen Wallpaper"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Tạo thư mục nếu chưa có
    sudo mkdir -p "$LOGIN_WALLPAPER_DIR"

    # Chọn wallpaper ngẫu nhiên hoặc một ảnh cụ thể
    if [ -n "$1" ] && [ -f "$1" ]; then
        SELECTED_WALLPAPER="$1"
        echo "✓ Sử dụng wallpaper được chỉ định: $(basename "$SELECTED_WALLPAPER")"
    else
        # Chọn ngẫu nhiên từ thư mục wallpapers
        SELECTED_WALLPAPER=$(find "$WALLPAPER_SOURCE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) 2>/dev/null | shuf -n 1)

        if [ -z "$SELECTED_WALLPAPER" ]; then
            echo "❌ Error: Không tìm thấy wallpaper nào trong $WALLPAPER_SOURCE_DIR"
            exit 1
        fi

        echo "✓ Chọn ngẫu nhiên: $(basename "$SELECTED_WALLPAPER")"
    fi

    # Copy wallpaper vào thư mục login
    WALLPAPER_EXT="${SELECTED_WALLPAPER##*.}"
    TARGET_PATH="$LOGIN_WALLPAPER_DIR/wallpaper.$WALLPAPER_EXT"

    sudo cp "$SELECTED_WALLPAPER" "$TARGET_PATH"
    sudo chmod 644 "$TARGET_PATH"

    # Tạo symlink để regreet có thể tìm thấy
    sudo ln -sf "wallpaper.$WALLPAPER_EXT" "$LOGIN_WALLPAPER_LINK"

    echo "✓ Đã copy wallpaper vào $TARGET_PATH"
    echo "✓ Login screen wallpaper đã được setup!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

show_current() {
    if [ -L "$LOGIN_WALLPAPER_LINK" ]; then
        CURRENT=$(readlink -f "$LOGIN_WALLPAPER_LINK")
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  Login Screen Wallpaper"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  Path: $CURRENT"
        if [ -f "$CURRENT" ]; then
            SIZE=$(du -h "$CURRENT" | cut -f1)
            echo "  Size: $SIZE"
        fi
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    else
        echo "⚠️  Chưa có wallpaper nào được setup cho login screen"
    fi
}

show_help() {
    cat << EOF
Login Wallpaper Setup - Setup wallpaper cho màn hình login

Cách sử dụng:
    login-wallpaper.sh [OPTION] [FILE]

Tùy chọn:
    setup [file]    Setup wallpaper (ngẫu nhiên hoặc từ file)
    current         Xem wallpaper hiện tại
    help            Hiển thị trợ giúp

Ví dụ:
    sudo login-wallpaper.sh setup
    sudo login-wallpaper.sh setup ~/Pictures/Wallpapers/my-wallpaper.jpg
    login-wallpaper.sh current

Lưu ý:
    - Lệnh setup cần quyền sudo
    - Wallpaper sẽ được copy vào /var/lib/greetd/
EOF
}

# Main
case "${1:-setup}" in
    setup)
        if [ "$EUID" -ne 0 ]; then
            echo "❌ Error: Lệnh này cần quyền sudo"
            echo "Chạy lại với: sudo $0 setup"
            exit 1
        fi
        setup_login_wallpaper "$2"
        ;;
    current)
        show_current
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ Error: Tùy chọn không hợp lệ: $1"
        echo "Sử dụng '$0 help' để xem trợ giúp"
        exit 1
        ;;
esac
