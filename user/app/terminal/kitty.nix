
{ config, pkgs, ... }:

{

  home.packages = [
    pkgs.kitty
  ];

  programs.kitty = {
    enable = ( config.my.user.settings.terminal == "kitty" );
  };
}
