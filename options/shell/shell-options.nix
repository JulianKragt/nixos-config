{ lib, ... }:

{
  options = {
    my.shell.aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        ".." = "cd ..";
      };
    };
    my.shell.shells = lib.mkOption {
      type = with lib.types; nonEmptyListOf (enum [ "bash" "zsh" "nushell" ]);
      default = [ "bash" ];
    };
  };
}
