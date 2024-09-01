{ config, pkgs, ...}:

{
  home.username = config.my.user.settings.username;
  home.homeDirectory = "/home/" + config.my.user.settings.username;

  imports = [
    ../../user/shell
    ../../user/wm
    ../../user/editor/neovim/neovim.nix
    ../../user/app/git/git.nix
  ];

  home.packages = [
    pkgs.neofetch
    pkgs.kitty
    pkgs.git
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
