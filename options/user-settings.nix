{ lib, ... }:

{
  options.my.user.settings = {
    username = lib.mkOption {
      type = lib.types.nonEmptyStr;
    };
    name = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "Used for certian options. Like, git";
    };
    email = lib.mkOption {
      type = lib.types.nonEmptyStr;
    };
    dotfilesDir = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "~/.dotfiles";
    };
    terminal = lib.mkOption {
      type = lib.types.enum [ "kitty" "alacritty" ];
    };
    editor = lib.mkOption {
      type = lib.types.enum [ "neovim" ];
    };
  };
}
