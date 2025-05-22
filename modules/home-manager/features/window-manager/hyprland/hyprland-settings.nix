{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    monitor = "eDP-1,1920x1080@60,0x0,1";
    exec-once = [
      
    ];
    bind = [
      "SUPER, A, exec, kitty"
      "SUPER, T, exec, firefox-beta"
      "SUPER, Q, killactive,"
      "SUPER, M, exit,"

      # Workspace
      "SUPER, Right, workspace, r+1"
      "SUPER, J, workspace, r-1"
      "SUPER, H, workspace, r-1"
      "SUPER, Left, workspace, r-1"
      "SUPER, K, workspace, r+1"
      "SUPER, L, workspace, r+1"
      "SUPER, Up, workspace, 1"

      # Move window to workspace
      "SHIFT SUPER, Right, movetoworkspace, r+1"
      "SHIFT SUPER, J, movetoworkspace, r-1"
      "SHIFT SUPER, H, movetoworkspace, r-1"
      "SHIFT SUPER, Left, movetoworkspace, r-1"
      "SHIFT SUPER, K, movetoworkspace, r+1"
      "SHIFT SUPER, L, movetoworkspace, r+1"
      "SHIFT SUPER, Up, movetoworkspace, 1"
      
      # Move window
      "SHIFT Alt_L, Up, movewindow, u"
      "SHIFT Alt_L, K, movewindow, u"
      "SHIFT Alt_L, Right, movewindow, r"
      "SHIFT Alt_L, L, movewindow, r"
      "SHIFT Alt_L, Down, movewindow, d"
      "SHIFT Alt_L, J, movewindow, d"
      "SHIFT Alt_L, Left, movewindow, l"
      "SHIFT Alt_L, H, movewindow, l"

      # Move focus
      "Alt_L, Up, movefocus, u"
      "Alt_L, K, movefocus, u"
      "Alt_L, Right, movefocus, r"
      "Alt_L, L, movefocus, r"
      "Alt_L, Down, movefocus, d"
      "Alt_L, J, movefocus, d"
      "Alt_L, Left, movefocus, l"
      "Alt_L, H, movefocus, l"
    ];

    general = {
      gaps_out = "10, 15, 15, 15";
    };

    input = {
      touchpad = {
        scroll_factor = 0.2;
        natural_scroll = true;
      };
    };
    device = {
      name = "logitch-gaming-mouse-g502";
      sensitivity = -0.3;
    };
    windowrulev2 = [
      "suppressevent maximize, class:.*"
      # "move 100%-20, class:.blueman-applet-wrapped"
    ];
  };
}
