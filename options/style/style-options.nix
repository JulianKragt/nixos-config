{ lib, ... }:

{
  options.my.style = {
    windowManager = lib.mkOption {
      type = lib.types.enum [ "hyprland" ];
    };
    fonts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Nerdfonts to install";
    };
    font = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "font to use";
    };
    theme = lib.mkOption {
      type = lib.types.str;
    };
  };
}
