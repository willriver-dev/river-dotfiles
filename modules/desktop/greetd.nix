{ config, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.regreet}/bin/regreet";
        user = "greeter";
      };

      initial_session = {
        command = "niri-session";
        user = "will";
      };
    };
  };

  # Cấu hình regreet
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/var/lib/greetd/wallpaper";
        fit = "Cover";
      };

      GTK = {
        application_prefer_dark_theme = true;
        cursor_theme_name = "Adwaita";
        font_name = "Inter 12";
        icon_theme_name = "Papirus-Dark";
        theme_name = "Adwaita-dark";
        # Sử dụng CSS tùy chỉnh
        css_path = "/etc/greetd/style.css";
      };

      appearance = {
        greeting_msg = "Welcome back! 🌟";
      };

      commands = {
        reboot = [ "systemctl" "reboot" ];
        poweroff = [ "systemctl" "poweroff" ];
      };
    };
  };

  # Copy CSS file vào /etc/greetd
  environment.etc."greetd/style.css".source = ../../config/regreet/style.css;

  # Cấu hình để greeter có thể đọc wallpapers
  systemd.tmpfiles.rules = [
    "d /var/lib/greetd 0755 greeter greeter -"
    "d /home/will/Pictures 0755 will users -"
    "d /home/will/Pictures/Wallpapers 0755 will users -"
  ];

  # Script để setup wallpaper cho login screen
  environment.systemPackages = with pkgs; [
    # Icon themes
    papirus-icon-theme
    adwaita-icon-theme

    # GTK themes
    adw-gtk3

    # Fonts
    inter
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji

    # Script để quản lý login wallpaper
    (writeShellScriptBin "login-wallpaper" (builtins.readFile ../../scripts/login-wallpaper.sh))
  ];

  # Cấu hình cage cho regreet (Wayland compositor nhẹ cho login screen)
  programs.regreet.cageArgs = [
    "-s"  # Single window mode
    "-m"  # Set last mode
    "last"
  ];

  # Cho phép greeter user truy cập
  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
    home = "/var/lib/greetd";
    createHome = true;
  };

  users.groups.greeter = {};

  # Activation script để setup wallpaper mặc định khi rebuild
  system.activationScripts.setupLoginWallpaper = {
    text = ''
      WALLPAPER_SOURCE="/home/will/Pictures/Wallpapers"
      LOGIN_WALLPAPER_DIR="/var/lib/greetd"

      # Tạo thư mục nếu chưa có
      mkdir -p "$LOGIN_WALLPAPER_DIR"

      # Nếu chưa có wallpaper, chọn ngẫu nhiên một ảnh
      if [ ! -e "$LOGIN_WALLPAPER_DIR/wallpaper" ] && [ -d "$WALLPAPER_SOURCE" ]; then
        SELECTED=$(find "$WALLPAPER_SOURCE" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) 2>/dev/null | shuf -n 1)
        if [ -n "$SELECTED" ]; then
          EXT="''${SELECTED##*.}"
          cp "$SELECTED" "$LOGIN_WALLPAPER_DIR/wallpaper.$EXT"
          ln -sf "wallpaper.$EXT" "$LOGIN_WALLPAPER_DIR/wallpaper"
          chmod 644 "$LOGIN_WALLPAPER_DIR/wallpaper.$EXT"
          chown greeter:greeter "$LOGIN_WALLPAPER_DIR/wallpaper"*
          echo "✓ Login wallpaper setup complete"
        fi
      fi
    '';
    deps = [];
  };

  # Font configuration cho render đẹp hơn
  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Inter" "Noto Sans" ];
      serif = [ "Noto Serif" ];
      monospace = [ "JetBrains Mono" "Noto Sans Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
