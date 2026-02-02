{ config, pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl wlsunset wl-clipboard
    grim slurp swappy
    swww cliphist cava
    xdg-desktop-portal xdg-desktop-portal-gtk
  ];
}
