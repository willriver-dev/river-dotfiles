{ config, pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    
    packages = with pkgs; [
      nerd-fonts.lilex
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji  # ← PHẢI SỬA DÒNG NÀY
      
      liberation_ttf
      dejavu_fonts
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "LilexNerdFont" "FiraCode Nerd Font" ];
        sansSerif = [ "Noto Sans" "DejaVu Sans" ];
        serif = [ "Noto Serif" "DejaVu Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
