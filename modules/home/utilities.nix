{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    pavucontrol blueman zathura imv yazi
  ];
}
