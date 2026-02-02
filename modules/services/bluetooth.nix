{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        ControllerMode = "dual";
        AutoEnable = true;
      };
    };
  };

  services.blueman.enable = true;
}
