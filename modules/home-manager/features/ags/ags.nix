{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.ags.homeManagerModules.default ];

  # programs.ags = {
  #   enable = true;
  #   configDir = ./ags.nix;
  #   extraPackages = [
  #     inputs.ags.packages.${pkgs.system}.battery
  #   ];
  # };

  home.packages = [
    inputs.ags.packages.${pkgs.system}.io
  ];
}
