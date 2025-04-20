{
  lib,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
  };

  myHomeManager.hyprland-settings.enable = lib.mkDefault true;
  myHomeManager.hyprlock.enable = lib.mkDefault true;
}
