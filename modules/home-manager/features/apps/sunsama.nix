{
  pkgs,
  ...
}:
let
  sunsama = pkgs.callPackage ../../../../pkgs/sunsama.nix {};
in {
  home.packages = [
      sunsama
  ];
}
