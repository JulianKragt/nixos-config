{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/users/users.nix
    inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia
  ];

  myNixOS.home-users = {
    "jkragt" = {
      homeFilePath = ./../../home/jkragt/home.nix;
      userSettings = {
        extraGroups = ["wheel"];
      };
    };
  };

  hardware.nvidia.powerManagement.enable = false;
  hardware.intelgpu.driver = "xe";

  home-manager.extraSpecialArgs = { inherit inputs; };
  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;

  myNixOS.bundles.connectivity.enable = true;
  myNixOS.bundles.window-managers.enable = true;
  myNixOS.systemd-boot.enable = true;
  myNixOS.ly.enable = true;
  environment.systemPackages = [
    pkgs.unzip
  ];

  system.stateVersion = "25.05";
}
