{ config, inputs, pkgs, ...}:

{
  programs.hyprland = {
    enable = (config.my.style.windowManager == "hyprland");
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

}
