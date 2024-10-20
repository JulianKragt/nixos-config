{ config , ... }:
{
  imports = [
    ./hyprland/settings.nix
  ];
  wayland.windowManager.hyprland.enable = true; 
}
