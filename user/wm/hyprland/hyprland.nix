{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = (config.my.style.windowManager == "hyprland");
    settings = {
     "$mod" = "SUPER";
      monitor = "eDP-1,1920x1080@60,0x0,1";
      bind = [
        "$mod, Q, exec, kitty"
        "$mod, T, exec, firefox"
	"$mod, C, killactive,"
	"$mod, M, exit,"
      ];

      general = {
        gaps_out = "10, 15, 15, 15";
      };

      input = {
        touchpad = {
	  scroll_factor = 0.2;
	};
      };
      windowrulev2 = "suppressevent maximize, class:.*";
    };
    extraConfig = ''
      exec-once = waybar
    '';
  };
}
