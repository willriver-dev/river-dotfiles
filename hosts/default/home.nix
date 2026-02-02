{ config, pkgs, noctalia, ... }:

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
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  programs.home-manager.enable = true;

  xdg.configFile."niri/config.kdl".source = ../../config/niri/config.kdl;
  xdg.configFile."noctalia/settings.json".source = ../../config/noctalia/settings.json;
  xdg.configFile."noctalia/colors.json".source = ../../config/noctalia/colors.json;
  xdg.configFile."noctalia/plugins.json".source = ../../config/noctalia/plugins.json;

  home.file."Pictures/Wallpapers/.keep".text = "";
  home.file."Pictures/Screenshots/.keep".text = "";

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    TERMINAL = "ghostty";
  };
}
