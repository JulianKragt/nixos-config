{
  pkgs,
  ...
}:
{
  system.stateVersion = "25.11";
#  users.users.jkragt = {
#    isNormalUser = true;
#    extraGroups = [ "wheel" ];
#  };
  environment.systemPackages = with pkgs; [ vim git curl wget ];

  my.users = {
    "jkragt" = {
      homeFilePath = ./../../home/jkragt/wsl-home.nix;
      userSettings = {
        extraGroups = [ "wheel" ];
      };
    };
  };
  wsl.defaultUser = "jkragt";
}
