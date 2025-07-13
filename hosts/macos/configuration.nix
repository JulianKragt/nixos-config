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
  myMacOS.editor.neovim.enable = true;

  system.stateVersion = 6;
}
