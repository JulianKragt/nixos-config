{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = (config.my.style.windowManager == "hyprland");
    settings = {
     "$mainMod" = "SUPER";
      monitor = "eDP-1,1920x1080@60,0x0,1";
      bind = [
        "$mainMod, Q, exec, kitty"
        "$mainMod, T, exec, firefox"
	"$mainMod, C, killactive,"
	"$mainMod, M, exit,"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
	"Control_L, Right, workspace, r+1"
	"Control_L, Left, workspace, r-1"
	"Control_L, Up, workspace, 1"
      ];

      general = {
        gaps_out = "10, 15, 15, 15";
      };

      input = {
        touchpad = {
	  scroll_factor = 0.2;
	};
      };
      windowrulev2 = [
        "suppressevent maximize, class:.*"
	# "move 100%-20, class:.blueman-applet-wrapped"
      ];

    };
    extraConfig = ''
      exec-once = waybar
    '';
  };
}
