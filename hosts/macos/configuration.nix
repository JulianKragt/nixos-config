{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./../../modules/users/users-macos.nix
  ];


  myMacOS.home-users = {
    "jkragt" = {
      homeFilePath = ./../../home/jkragt/macos-home.nix;
    };
  };

  environment.systemPackages = [
    pkgs.git
#    pkgs.jetbrains.phpstorm
#    inputs.nixvim.packages.${pkgs.system}.default
  ];


  system.stateVersion = 6;
}