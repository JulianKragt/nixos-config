{ ... }:
{
  programs.hyprlock = {
    enable = true;
  };

  wayland.windowManager.hyprland.settings.bind = [
    "ALT_R, P, exec, hyprlock"
  ];
}
