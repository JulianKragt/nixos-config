{
  # Darwin tiling WM (the closest equivalent to niri/sway on Linux).
  # Imported by per-(user,host) HM files on Mac via self.homeModules.desktop-aerospace.
  flake.homeModules.desktop-aerospace =
    { lib, pkgs, ... }:
    {
      home.packages = lib.mkIf pkgs.stdenv.isDarwin [
        # Aerospace is in nixpkgs as `aerospace` on darwin systems.
        pkgs.aerospace
      ];

      # Drop a minimal config; the user can override fully in their per-(user,host) module.
      home.file.".config/aerospace/aerospace.toml" = lib.mkIf pkgs.stdenv.isDarwin {
        text = ''
          start-at-login = true
          enable-normalization-flatten-containers = true
          enable-normalization-opposite-orientation-for-nested-containers = true

          accordion-padding = 30
          default-root-container-layout = 'tiles'
          default-root-container-orientation = 'auto'

          [mode.main.binding]
          alt-h = 'focus left'
          alt-j = 'focus down'
          alt-k = 'focus up'
          alt-l = 'focus right'

          alt-shift-h = 'move left'
          alt-shift-j = 'move down'
          alt-shift-k = 'move up'
          alt-shift-l = 'move right'

          alt-1 = 'workspace 1'
          alt-2 = 'workspace 2'
          alt-3 = 'workspace 3'
          alt-4 = 'workspace 4'

          alt-shift-1 = 'move-node-to-workspace 1'
          alt-shift-2 = 'move-node-to-workspace 2'
          alt-shift-3 = 'move-node-to-workspace 3'
          alt-shift-4 = 'move-node-to-workspace 4'
        '';
      };
    };
}
