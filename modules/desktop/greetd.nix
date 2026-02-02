{ config, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
      
      initial_session = {
        command = "niri-session";
        user = "nixos";  # ĐỔI thành username của bạn
      };
    };
  };

  environment.systemPackages = [ pkgs.tuigreet ];
}
