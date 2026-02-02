#!/usr/bin/env bash

# ============================================================================
# NixOS Dotfiles Installer - Simple Bootstrap
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}→${NC} $1"
}

ask() {
    local prompt="$1"
    local default="$2"

    if [ -n "$default" ]; then
        echo -ne "${YELLOW}?${NC} $prompt [${GREEN}$default${NC}]: "
    else
        echo -ne "${YELLOW}?${NC} $prompt: "
    fi

    read response
    echo "${response:-$default}"
}

ask_password() {
    local pass1 pass2
    while true; do
        echo -ne "${YELLOW}?${NC} Nhập password mới: "
        read -s pass1
        echo
        echo -ne "${YELLOW}?${NC} Nhập lại password: "
        read -s pass2
        echo

        if [ "$pass1" != "$pass2" ]; then
            print_error "Password không khớp! Thử lại."
            continue
        fi

        if [ ${#pass1} -lt 4 ]; then
            print_error "Password quá ngắn! (tối thiểu 4 ký tự)"
            continue
        fi

        echo "$pass1"
        break
    done
}

# ============================================================================
# Main Setup
# ============================================================================

clear
echo -e "${GREEN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║         NixOS + Niri + Noctalia Shell Installer          ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

print_info "Script này sẽ giúp bạn setup dotfiles trên máy của bạn"
echo ""

# ============================================================================
# Step 1: Thu thập thông tin
# ============================================================================

print_header "Bước 1: Thông tin cơ bản"

USERNAME=$(ask "Tên user" "$(whoami)")
HOSTNAME=$(ask "Hostname" "nixos")
FULLNAME=$(ask "Tên đầy đủ (cho Git)" "$USERNAME")
EMAIL=$(ask "Email (cho Git)" "${USERNAME}@example.com")

echo ""
print_info "Tạo password cho user $USERNAME"
PASSWORD=$(ask_password)
print_success "Password đã được tạo!"

echo ""
print_info "Thông tin của bạn:"
echo "  • Username: $USERNAME"
echo "  • Hostname: $HOSTNAME"
echo "  • Full Name: $FULLNAME"
echo "  • Email: $EMAIL"
echo "  • Password: ******** (đã mã hóa)"
echo ""

# ============================================================================
# Step 2: Generate hardware config
# ============================================================================

print_header "Bước 2: Tạo hardware configuration"

HARDWARE_FILE="$SCRIPT_DIR/hosts/default/hardware-configuration.nix"

if [ -f "$HARDWARE_FILE" ]; then
    print_info "File hardware-configuration.nix đã tồn tại"
    echo -ne "${YELLOW}?${NC} Generate lại? [y/N]: "
    read regen
    if [[ "$regen" =~ ^[Yy]$ ]]; then
        print_info "Đang generate hardware config..."
        sudo nixos-generate-config --show-hardware-config > "$HARDWARE_FILE"
        print_success "Đã tạo hardware-configuration.nix"
    fi
else
    print_info "Đang generate hardware config..."
    sudo nixos-generate-config --show-hardware-config > "$HARDWARE_FILE"
    print_success "Đã tạo hardware-configuration.nix"
fi

# ============================================================================
# Step 3: Cập nhật config files
# ============================================================================

print_header "Bước 3: Cập nhật config files"

# Update configuration.nix
print_info "Cập nhật configuration.nix..."
sed -i "s/networking.hostName = \".*\";/networking.hostName = \"$HOSTNAME\";/" \
    "$SCRIPT_DIR/hosts/default/configuration.nix"
sed -i "s/users.users.will/users.users.$USERNAME/g" \
    "$SCRIPT_DIR/hosts/default/configuration.nix"

# Update password
print_info "Cập nhật password..."
sed -i "s/initialPassword = \"changeme\";/initialPassword = \"$PASSWORD\";/" \
    "$SCRIPT_DIR/hosts/default/configuration.nix"

# Update home.nix
print_info "Cập nhật home.nix..."
sed -i "s/home.username = \".*\";/home.username = \"$USERNAME\";/" \
    "$SCRIPT_DIR/hosts/default/home.nix"
sed -i "s|home.homeDirectory = \".*\";|home.homeDirectory = \"/home/$USERNAME\";|" \
    "$SCRIPT_DIR/hosts/default/home.nix"

# Update flake.nix
print_info "Cập nhật flake.nix..."
sed -i "s/home-manager.users.will/home-manager.users.$USERNAME/g" \
    "$SCRIPT_DIR/flake.nix"
sed -i "s/river = nixpkgs.lib.nixosSystem/$HOSTNAME = nixpkgs.lib.nixosSystem/" \
    "$SCRIPT_DIR/flake.nix"

# Update git.nix
print_info "Cập nhật git.nix..."
sed -i "s/name = \".*\";/name = \"$FULLNAME\";/" \
    "$SCRIPT_DIR/modules/home/git.nix"
sed -i "s/email = \".*\";/email = \"$EMAIL\";/" \
    "$SCRIPT_DIR/modules/home/git.nix"

# Update greetd.nix (login screen)
print_info "Cập nhật greetd.nix..."
sed -i "s/user = \"will\";/user = \"$USERNAME\";/g" \
    "$SCRIPT_DIR/modules/desktop/greetd.nix"
sed -i "s|/home/will/|/home/$USERNAME/|g" \
    "$SCRIPT_DIR/modules/desktop/greetd.nix"

# Update wallpaper scripts
print_info "Cập nhật wallpaper scripts..."
sed -i "s|/home/will/|/home/$USERNAME/|g" \
    "$SCRIPT_DIR/scripts/login-wallpaper.sh"

print_success "Đã cập nhật tất cả config files"

# ============================================================================
# Step 4: Lưu thông tin
# ============================================================================

print_header "Bước 4: Lưu thông tin"

cat > "$SCRIPT_DIR/.install-info" << EOF
# Installation Info
USERNAME="$USERNAME"
HOSTNAME="$HOSTNAME"
FULLNAME="$FULLNAME"
EMAIL="$EMAIL"
INSTALL_DATE="$(date +%Y-%m-%d)"
EOF

print_success "Đã lưu thông tin cài đặt"

# ============================================================================
# Hoàn tất
# ============================================================================

print_header "🎉 Hoàn tất!"

echo -e "${GREEN}Setup đã xong! Bạn có thể build hệ thống bằng lệnh:${NC}"
echo ""
echo -e "  ${CYAN}cd $SCRIPT_DIR${NC}"
echo -e "  ${CYAN}sudo nixos-rebuild switch --flake .#$HOSTNAME${NC}"
echo ""
echo -e "${YELLOW}Lưu ý:${NC}"
echo "  • Username: ${GREEN}$USERNAME${NC}"
echo "  • Password: ${GREEN}(đã lưu)${NC}"
echo "  • Sau khi build xong, hãy ${CYAN}reboot${NC}"
echo "  • Đổi password sau khi đăng nhập: ${CYAN}passwd${NC}"
echo ""
echo -e "${BLUE}Thưởng thức NixOS của bạn! 🚀${NC}"
echo ""
