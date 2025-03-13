{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  programs.kitty.enable = true;
  wayland.windowManager.hyprland.enable = true;
  myHomeManager.hyprland-settings.enable = lib.mkDefault true;
}
