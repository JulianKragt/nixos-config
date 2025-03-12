{
    inputs,
    myLib,
    ...
}:
{
    imports = [
        ./hardware-configuration.nix
        ./../../modules/users/users.nix
    ];

    myNixOS.home-users = {
        "jkragt" = {
            homeFilePath = ./../../home/jkragt/home.nix;
            userSettings = {
                extraGroups = ["wheel"];
            };
        };
    };
   
    myNixOS.bundles.connectivity.enable = true;
    myNixOS.systemd-boot.enable = true;

    home-manager.extraSpecialArgs = { inherit inputs myLib; };

    system.stateVersion = "25.05";
#    system.stateVersion = "24.11";
}
