{ config, pkgs, ...}:

{
  home.username = config.my.user.settings.username;
  home.homeDirectory = "/home/" + config.my.user.settings.username;

  imports = [
    ../../user/shell
    ../../user/wm/hyprland.nix
    ../../user/editor/nixvim/nixvim.nix
    ../../user/app/git/git.nix
    ../../user/fonts/fonts.nix
    ../../user/app/terminal/kitty.nix
    ../../user/style/stylix.nix
    ../../user/app/firefox.nix
  ];

  home.packages = [
    pkgs.neofetch
    pkgs.git
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
