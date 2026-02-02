{ config, pkgs, noctalia, ... }:

let
  wallpaperManager = pkgs.writeShellScriptBin "wallpaper-manager" (builtins.readFile ../../scripts/wallpaper-manager.sh);

  wallpaperChanger = pkgs.writeShellScriptBin "wallpaper-changer" ''
    #!/usr/bin/env bash
    INTERVAL=1800  # Đổi ảnh mỗi 30 phút (1800 giây)

    # Khởi tạo swww daemon
    ${wallpaperManager}/bin/wallpaper-manager init

    # Đặt ảnh nền ban đầu với hiệu ứng đẹp
    SWWW_TRANSITION=grow SWWW_DURATION=3 ${wallpaperManager}/bin/wallpaper-manager random

    # Vòng lặp thay đổi ảnh nền với các hiệu ứng ngẫu nhiên
    TRANSITIONS=("fade" "wipe" "grow" "outer" "wave")
    while true; do
      sleep $INTERVAL
      # Chọn hiệu ứng ngẫu nhiên
      RANDOM_TRANSITION=''${TRANSITIONS[$RANDOM % ''${#TRANSITIONS[@]}]}
      SWWW_TRANSITION=$RANDOM_TRANSITION ${wallpaperManager}/bin/wallpaper-manager random
    done
  '';
in
{
  imports = [
    ../../modules/home/development.nix
    ../../modules/home/helix.nix
    ../../modules/home/git.nix
    ../../modules/home/shell.nix
    ../../modules/home/terminals.nix
    ../../modules/home/browsers.nix
    ../../modules/home/utilities.nix
  ];

  home.stateVersion = "25.11";
  home.username = "will";
  home.homeDirectory = "/home/will";

  programs.home-manager.enable = true;

  # Copy wallpapers từ dotfiles vào Pictures/Wallpapers
  home.activation.copyWallpapers = config.lib.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/Pictures/Wallpapers
    $DRY_RUN_CMD cp -rf ${../../wallpapers}/* $HOME/Pictures/Wallpapers/
    $DRY_RUN_CMD chmod -R u+w $HOME/Pictures/Wallpapers
    echo "Wallpapers copied successfully!"
  '';

  xdg.configFile."niri/config.kdl".source = ../../config/niri/config.kdl;
  xdg.configFile."noctalia/settings.json".source = ../../config/noctalia/settings.json;
  xdg.configFile."noctalia/colors.json".source = ../../config/noctalia/colors.json;
  xdg.configFile."noctalia/plugins.json".source = ../../config/noctalia/plugins.json;

  home.file."Pictures/Wallpapers/.keep".text = "";
  home.file."Pictures/Screenshots/.keep".text = "";

  # Cài đặt swww để quản lý ảnh nền (đã có sẵn trong system packages)
  home.packages = with pkgs; [
    wallpaperManager
    wallpaperChanger
  ];

  # Service tự động chuyển ảnh nền với swww
  systemd.user.services.wallpaper-changer = {
    Unit = {
      Description = "Automatic wallpaper changer for Niri using swww";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${wallpaperChanger}/bin/wallpaper-changer";
      Restart = "on-failure";
      RestartSec = 10;
      Environment = "PATH=${pkgs.swww}/bin:${pkgs.findutils}/bin:${pkgs.coreutils}/bin:${pkgs.bash}/bin";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    TERMINAL = "ghostty";
  };
}
