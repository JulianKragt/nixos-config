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

#  my.mac.php83.enable = true;

  system.primaryUser = "jkragt";

  system.stateVersion = 6;
}