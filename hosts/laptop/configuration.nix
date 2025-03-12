{
    inputs,
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
    
    home-manager.extraSpecialArgs = { inherit inputs; };
   
    myNixOS.bundles.connectivity.enable = true;
    myNixOS.systemd-boot.enable = true;

    system.stateVersion = "25.05";
}
