{ config, pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.ly
  ];
  services.displayManager.ly.enable = true;
  # services.displayManager.ly.enable = (config.my.system.settings.displayManager == "ly");
  # services.displayManager.ly.package = pkgs-unstable.ly;
}
