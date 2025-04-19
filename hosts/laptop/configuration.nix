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

  environment.systemPackages = [ pkgs.hyprland ];
  environment.pathsToLink = [ "/share/wayland-sessions" ];

  home-manager.extraSpecialArgs = { inherit inputs; };
  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;

  myNixOS.bundles.connectivity.enable = true;
  myNixOS.systemd-boot.enable = true;
  myNixOS.ly.enable = true;

  system.stateVersion = "25.05";
}
