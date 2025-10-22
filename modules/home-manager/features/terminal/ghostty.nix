{
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then false else pkgs.ghostty;
  };
#
#
#  home.file."Applications/Ghostty.app" = {
#    source = "${pkgs.ghostty-bin}/Applications/Ghostty.app";
#    recursive = true;
#  };
}