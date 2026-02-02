{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ghostty alacritty kitty
  ];
}
