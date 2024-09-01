{ lib, ... }:

{
  options.my.style = {
    windowManager = lib.mkOption {
      type = lib.types.enum [ "hyprland" ];
    };
    font = lib.mkOption {
      type = lib.types.nonEmptyStr;
    };
    theme = lib.mkOption {
      type = lib.types.enum [ "" ];
    };
  };
}
