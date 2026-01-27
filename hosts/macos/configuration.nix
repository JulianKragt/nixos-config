{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./settings.nix
    inputs.nix-homebrew.darwinModules.nix-homebrew {
      nix-homebrew = {
        enable = true;
        user = "jkragt";
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
        };
        mutableTaps = false;
      };
    }
  ];

  users.users."jkragt" = {
  };
  homebrew.enable = true;

  my.mac.services.ssh.enable = true;
  my.mac.homebrew.onedrive.enable = true;
  my.mac.homebrew.php.enable = true;

  system.primaryUser = "jkragt";

  system.stateVersion = 6;

}

