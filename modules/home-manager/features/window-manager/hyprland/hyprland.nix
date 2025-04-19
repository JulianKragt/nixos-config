{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  hyprlandPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprlandPkgs.hyprland;
    portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
  };

  xdg.dataFile."wayland-sessions/hyprland.desktop".source = 
    "${hyprlandPkgs.hyprland}/share/wayland-sessions/hyprland.desktop";

  myHomeManager.hyprland-settings.enable = lib.mkDefault true;
  myHomeManager.hyprlock.enable = lib.mkDefault true;
}
