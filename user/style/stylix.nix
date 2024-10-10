{ config, pkgs, ... }:

let
  themePath = "../../../themes/${config.my.style.theme}.yaml";
in
{
  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.base16Scheme = ./. + themePath;
  stylix.image = pkgs.fetchurl {
    url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  };

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
  stylix.targets.nixvim.enable = true;

}
