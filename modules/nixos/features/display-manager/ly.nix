{ ... }:
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      waylandsessions = "/run/current-system/sw/share/wayland-sessions";
    };
  };
}
