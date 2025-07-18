{
  pkgs,
  inputs,
  ...
}:
{
_module.args.experimentalFeatures.pipes = true;
  imports = [
    ./../../modules/users/users-macos.nix
  ];

  myMacOS.home-users = {
    "jkragt" = {
      homeFilePath = ./../../home/jkragt/macos-home.nix;
    };
  };

  myMacOS.editor.neovim.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = 6;
}
