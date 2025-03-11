{
  pkgs,
  inputs,
  ...
}:
{
    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland = {
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
#        portalPackage = inputs.hyprland.packages.${pkg.stdenv.hostPlatform.system}.hyprland;
    };
}
