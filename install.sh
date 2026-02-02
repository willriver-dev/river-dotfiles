#!/usr/bin/env bash

# Simple NixOS Dotfiles Installer
set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   NixOS Dotfiles Installer                ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
echo ""

# Get current directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Collect information
echo -e "${BLUE}==> Thông tin cơ bản${NC}"
echo ""

read -p "Username [$(whoami)]: " USERNAME
USERNAME=${USERNAME:-$(whoami)}

read -p "Hostname [nixos]: " HOSTNAME
HOSTNAME=${HOSTNAME:-nixos}

read -p "Full Name (Git) [$USERNAME]: " FULLNAME
FULLNAME=${FULLNAME:-$USERNAME}

read -p "Email (Git) [${USERNAME}@example.com]: " EMAIL
EMAIL=${EMAIL:-${USERNAME}@example.com}

echo ""
read -sp "Password: " PASSWORD1
echo ""
read -sp "Confirm Password: " PASSWORD2
echo ""

if [ "$PASSWORD1" != "$PASSWORD2" ]; then
    echo -e "${RED}✗ Password không khớp!${NC}"
    exit 1
fi

if [ ${#PASSWORD1} -lt 4 ]; then
    echo -e "${RED}✗ Password quá ngắn!${NC}"
    exit 1
fi

PASSWORD=$PASSWORD1

# Summary
echo ""
echo -e "${BLUE}==> Xác nhận thông tin${NC}"
echo "  Username:  $USERNAME"
echo "  Hostname:  $HOSTNAME"
echo "  Full Name: $FULLNAME"
echo "  Email:     $EMAIL"
echo ""
read -p "Tiếp tục? [Y/n] " CONFIRM
if [[ $CONFIRM =~ ^[Nn]$ ]]; then
    echo "Đã hủy."
    exit 0
fi

# Generate hardware config
echo ""
echo -e "${BLUE}==> Tạo hardware configuration${NC}"
HARDWARE_FILE="$DOTFILES_DIR/hosts/default/hardware-configuration.nix"

if [ -f "$HARDWARE_FILE" ]; then
    echo "File hardware-configuration.nix đã tồn tại."
    read -p "Generate lại? [y/N] " REGEN
    if [[ $REGEN =~ ^[Yy]$ ]]; then
        sudo nixos-generate-config --show-hardware-config > "$HARDWARE_FILE"
        echo -e "${GREEN}✓ Đã tạo hardware-configuration.nix${NC}"
    fi
else
    sudo nixos-generate-config --show-hardware-config > "$HARDWARE_FILE"
    echo -e "${GREEN}✓ Đã tạo hardware-configuration.nix${NC}"
fi

# Update configs
echo ""
echo -e "${BLUE}==> Cập nhật config files${NC}"

# configuration.nix
sed -i "s/networking.hostName = \".*\";/networking.hostName = \"$HOSTNAME\";/" \
    "$DOTFILES_DIR/hosts/default/configuration.nix"
sed -i "s/users.users.will/users.users.$USERNAME/g" \
    "$DOTFILES_DIR/hosts/default/configuration.nix"
sed -i "s/initialPassword = \"changeme\";/initialPassword = \"$PASSWORD\";/" \
    "$DOTFILES_DIR/hosts/default/configuration.nix"

# home.nix
sed -i "s/home.username = \".*\";/home.username = \"$USERNAME\";/" \
    "$DOTFILES_DIR/hosts/default/home.nix"
sed -i "s|home.homeDirectory = \".*\";|home.homeDirectory = \"/home/$USERNAME\";|" \
    "$DOTFILES_DIR/hosts/default/home.nix"

# flake.nix
sed -i "s/home-manager.users.will/home-manager.users.$USERNAME/g" \
    "$DOTFILES_DIR/flake.nix"
sed -i "s/river = nixpkgs.lib.nixosSystem/$HOSTNAME = nixpkgs.lib.nixosSystem/" \
    "$DOTFILES_DIR/flake.nix"

# git.nix
sed -i "s/name = \".*\";/name = \"$FULLNAME\";/" \
    "$DOTFILES_DIR/modules/home/git.nix"
sed -i "s/email = \".*\";/email = \"$EMAIL\";/" \
    "$DOTFILES_DIR/modules/home/git.nix"

# greetd.nix
sed -i "s/user = \"will\";/user = \"$USERNAME\";/g" \
    "$DOTFILES_DIR/modules/desktop/greetd.nix"
sed -i "s|/home/will/|/home/$USERNAME/|g" \
    "$DOTFILES_DIR/modules/desktop/greetd.nix"

# wallpaper scripts
sed -i "s|/home/will/|/home/$USERNAME/|g" \
    "$DOTFILES_DIR/scripts/login-wallpaper.sh"

echo -e "${GREEN}✓ Đã cập nhật tất cả config files${NC}"

# Done
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ Setup hoàn tất!                      ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
echo ""
echo "Bây giờ bạn có thể build hệ thống:"
echo ""
echo -e "  ${YELLOW}cd $DOTFILES_DIR${NC}"
echo -e "  ${YELLOW}sudo nixos-rebuild switch --flake .#$HOSTNAME${NC}"
echo ""
echo "Sau đó reboot và đăng nhập với:"
echo "  Username: $USERNAME"
echo "  Password: (đã nhập)"
echo ""
echo -e "${BLUE}Chúc bạn có trải nghiệm NixOS tuyệt vời! 🚀${NC}"
echo ""
