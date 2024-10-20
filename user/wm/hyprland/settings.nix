


{ config, pkgs, lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1,1920x1080@60,0x0,1"
    ];
    exec-once = [
      
    ];
    bind = [
      "SUPER, A, exec, kitty"
      "SUPER, T, exec, firefox"
      "SUPER, Q, killactive,"
      "SUPER, M, exit,"

      # Workspace
      "Control_L SUPER, Right, workspace, r+1"
      "Control_L SUPER, J, workspace, r-1"
      "Control_L SUPER, H, workspace, r-1"
      "Control_L SUPER, Left, workspace, r-1"
      "Control_L SUPER, K, workspace, r+1"
      "Control_L SUPER, L, workspace, r+1"
      "Control_L SUPER, Up, workspace, 1"

      # Move window to workspace
      "Control_L SUPER, Right, movetoworkspace, r+1"
      "Control_L SUPER, J, movetoworkspace, r-1"
      "Control_L SUPER, H, movetoworkspace, r-1"
      "Control_L SUPER, Left, movetoworkspace, r-1"
      "Control_L SUPER, K, movetoworkspace, r+1"
      "Control_L SUPER, L, movetoworkspace, r+1"
      "Control_L SUPER, Up, movetoworkspace, 1"
      
      # Move window
      "SHIFT SUPER, Up, movewindow, u"
      "SHIFT SUPER, K, movewindow, u"
      "SHIFT SUPER, Right, movewindow, r"
      "SHIFT SUPER, L, movewindow, r"
      "SHIFT SUPER, Down, movewindow, d"
      "SHIFT SUPER, J, movewindow, d"
      "SHIFT SUPER, Left, movewindow, l"
      "SHIFT SUPER, H, movewindow, l"

      # Move focus
      "SUPER, Up, movefocus, u"
      "SUPER, K, movefocus, u"
      "SUPER, Right, movefocus, r"
      "SUPER, L, movefocus, r"
      "SUPER, Down, movefocus, d"
      "SUPER, J, movefocus, d"
      "SUPER, Left, movefocus, l"
      "SUPER, H, movefocus, l"
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
}
