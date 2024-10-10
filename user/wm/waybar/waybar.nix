{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        spacing = 2;
	modules-left = [
	  "clock"
	  "hyprland/workspaces"
	];
	modules-right = [
	  "bluetooth"
	  "wireplumber"
	  "network"
	  "battery"
	];

	bluetooth = {
	  on-click = "blueman-manager";
	};

	wireplumber = {
	  format = "{volume}%";
	  on-click = "helvum";
	};

	clock = {
	  timezone = config.my.system.settings.timezone;
	  tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
	    mode = "year";
	    mode-mon-col = 3;
	    weeks-pos = "right";
	    on-scroll = 1;
	    format = {
	      months = "<span color='#ffead3'><b>{}</b></span>";
	      days = "<span color='#ecc6d9'><b>{}</b></span>";
	      weeks = "<span color='#99ffdd'><b>W{}</b></span>";
	      weekdays = "<span color='#ffcc66'><b>{}</b></span>";
	      today = "<span color='#ff6699'><b><u>{}</u></b></span>";
	    };
          };
	};

	battery = {
	  bat = "BAT0";
	  interval = 60;
	  states = {  
	    "100" = 100;
	    "90" = 90;
	    "80" = 80;
	    "70" = 70;
	    "60" = 60;
	    "50" = 50;
	    "40" = 40;
	    "30" = 30;
	    "20" = 20;
	    "10" = 10;
	    "0" = 0;
	  };
	  format-charging-100 = "󰂅  {capacity}%";
	  format-charging-90  = "󰂋  {capacity}%";
	  format-charging-80  = "󰂊  {capacity}%";
	  format-charging-70  = "󰢞  {capacity}%";
	  format-charging-60  = "󰂉  {capacity}%";
	  format-charging-50  = "󰢝  {capacity}%";
	  format-charging-40  = "󰂈  {capacity}%";
	  format-charging-30  = "󰂇  {capacity}%";
	  format-charging-20  = "󰂆  {capacity}%";
	  format-charging-10  = "󰢜  {capacity}%";
	  format-charging-0   = "󰢟  {capacity}%";
	  format = "{icon}  {capacity}%";
	  format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
	};
	network = {
	  format-wifi = "{icon}";
	  format-disconnected = "󰤮";
	  format-ethernet = "";
	  tooltip-format-wifi = "{essid} ({signalStrength}%)";
	  format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
	};
      };
      "hyprland/workspaces" = {
      	format = "{icon}";
      	on-click = "activate";
      	format-icons = {
          "1" = "";
          "2" = "";
          "3" = "";
	  "4" = "";
	  "5" = "";
	  urgent = "";
	  active = "";
	  default = "";
     	};
     	sort-by-number = true;
      };
    };
  };
}
