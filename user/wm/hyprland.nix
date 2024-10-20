{ config , ... }:
{
  imports = [
    ./hyprland/settings.nix
  ];
  wayland.windowManager.hyperland.enable = true; 
}
