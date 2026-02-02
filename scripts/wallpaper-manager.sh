#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CURRENT_WALLPAPER_FILE="$HOME/.config/niri/current-wallpaper"

show_help() {
    cat << EOF
Wallpaper Manager - Quản lý ảnh nền cho Niri (sử dụng swww)

Cách sử dụng:
    wallpaper-manager [OPTION]

Tùy chọn:
    random          Chọn ảnh nền ngẫu nhiên
    next            Chuyển sang ảnh tiếp theo
    prev            Quay lại ảnh trước
    set <file>      Đặt ảnh nền từ file cụ thể
    list            Liệt kê tất cả ảnh nền có sẵn
    current         Hiển thị ảnh nền hiện tại
    init            Khởi tạo swww daemon
    help            Hiển thị trợ giúp này

Hiệu ứng transition:
    Sử dụng biến môi trường SWWW_TRANSITION để thay đổi:
    - simple, fade, wipe, grow, outer, random

Ví dụ:
    wallpaper-manager random
    wallpaper-manager set ~/Pictures/Wallpapers/my-wallpaper.jpg
    SWWW_TRANSITION=grow wallpaper-manager random
    wallpaper-manager list
EOF
}

init_swww() {
    # Kiểm tra xem swww-daemon đã chạy chưa
    if ! pgrep -x swww-daemon > /dev/null; then
        echo "Đang khởi động swww daemon..."
        swww-daemon &
        sleep 1
    fi
}

set_wallpaper() {
    local wallpaper="$1"
    local transition="${SWWW_TRANSITION:-fade}"
    local duration="${SWWW_DURATION:-2}"

    if [ ! -f "$wallpaper" ]; then
        echo "❌ Error: File không tồn tại: $wallpaper"
        return 1
    fi

    # Khởi tạo swww nếu chưa chạy
    init_swww

    # Đặt ảnh nền với hiệu ứng
    swww img "$wallpaper" \
        --transition-type "$transition" \
        --transition-duration "$duration" \
        --transition-fps 60 \
        --transition-bezier 0.25,0.1,0.25,1.0

    # Lưu đường dẫn ảnh nền hiện tại
    mkdir -p "$(dirname "$CURRENT_WALLPAPER_FILE")"
    echo "$wallpaper" > "$CURRENT_WALLPAPER_FILE"

    echo "✓ Đã đổi ảnh nền: $(basename "$wallpaper")"
    echo "  Hiệu ứng: $transition"
}

random_wallpaper() {
    local wallpaper=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) 2>/dev/null | shuf -n 1)

    if [ -z "$wallpaper" ]; then
        echo "❌ Error: Không tìm thấy ảnh nền nào trong $WALLPAPER_DIR"
        return 1
    fi

    set_wallpaper "$wallpaper"
}

list_wallpapers() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Danh sách ảnh nền trong $WALLPAPER_DIR"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local count=0
    while IFS= read -r -d '' file; do
        count=$((count + 1))
        local size=$(du -h "$file" | cut -f1)
        printf "%3d. %-50s [%s]\n" "$count" "$(basename "$file")" "$size"
    done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 2>/dev/null | sort -z)

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Tổng cộng: $count ảnh"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

current_wallpaper() {
    if [ -f "$CURRENT_WALLPAPER_FILE" ]; then
        local current=$(cat "$CURRENT_WALLPAPER_FILE")
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  Ảnh nền hiện tại"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  Tên: $(basename "$current")"
        echo "  Đường dẫn: $current"
        if [ -f "$current" ]; then
            local size=$(du -h "$current" | cut -f1)
            local dimensions=$(file "$current" | grep -oP '\d+\s*x\s*\d+' | head -1)
            echo "  Kích thước: $size"
            [ -n "$dimensions" ] && echo "  Độ phân giải: $dimensions"
        fi
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    else
        echo "⚠️  Chưa có ảnh nền nào được đặt"
    fi
}

next_wallpaper() {
    local wallpapers=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) 2>/dev/null | sort))
    local total=${#wallpapers[@]}

    if [ $total -eq 0 ]; then
        echo "❌ Error: Không tìm thấy ảnh nền nào"
        return 1
    fi

    if [ -f "$CURRENT_WALLPAPER_FILE" ]; then
        local current=$(cat "$CURRENT_WALLPAPER_FILE")
        local current_index=-1

        for i in "${!wallpapers[@]}"; do
            if [ "${wallpapers[$i]}" = "$current" ]; then
                current_index=$i
                break
            fi
        done

        local next_index=$(( (current_index + 1) % total ))
        set_wallpaper "${wallpapers[$next_index]}"
    else
        set_wallpaper "${wallpapers[0]}"
    fi
}

prev_wallpaper() {
    local wallpapers=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) 2>/dev/null | sort))
    local total=${#wallpapers[@]}

    if [ $total -eq 0 ]; then
        echo "❌ Error: Không tìm thấy ảnh nền nào"
        return 1
    fi

    if [ -f "$CURRENT_WALLPAPER_FILE" ]; then
        local current=$(cat "$CURRENT_WALLPAPER_FILE")
        local current_index=-1

        for i in "${!wallpapers[@]}"; do
            if [ "${wallpapers[$i]}" = "$current" ]; then
                current_index=$i
                break
            fi
        done

        local prev_index=$(( (current_index - 1 + total) % total ))
        set_wallpaper "${wallpapers[$prev_index]}"
    else
        set_wallpaper "${wallpapers[$((total - 1))]}"
    fi
}

# Main
case "${1:-random}" in
    random)
        random_wallpaper
        ;;
    next)
        next_wallpaper
        ;;
    prev)
        prev_wallpaper
        ;;
    set)
        if [ -z "$2" ]; then
            echo "❌ Error: Cần chỉ định file ảnh"
            echo "Ví dụ: wallpaper-manager set /path/to/image.jpg"
            exit 1
        fi
        set_wallpaper "$2"
        ;;
    list)
        list_wallpapers
        ;;
    current)
        current_wallpaper
        ;;
    init)
        init_swww
        echo "✓ swww daemon đã được khởi động"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ Error: Tùy chọn không hợp lệ: $1"
        echo "Sử dụng 'wallpaper-manager help' để xem trợ giúp"
        exit 1
        ;;
esac
