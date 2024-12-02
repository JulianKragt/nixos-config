{ config, pkgs, ... }:

let
  themePath = "../../../themes/${config.my.style.theme}.yaml";
in
{
  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.base16Scheme = ./. + themePath;

  stylix.cursor.size = 20;

  stylix.fonts = {
    sizes = {
      terminal = 10;
      applications = 12;
      popups = 12;
      desktop = 12;
    };
  };


  stylix.targets.kitty.enable = true;
}
