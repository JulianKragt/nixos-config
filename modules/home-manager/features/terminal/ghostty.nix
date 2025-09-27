{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.ghostty-bin
  ];

#  programs.ghostty = {
#    enable = true;
#    package = if pkgs.stdenv.isDarwin then false else pkgs.ghostty;
#  };
}