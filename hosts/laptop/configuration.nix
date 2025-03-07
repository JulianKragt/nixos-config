{ ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./../../modules/users/users.nix
        ./../../modules/nixos/boot-loader/systemd-boot.nix
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    myNixOS.home-users = {
        "jkragt" = {
            homeFilePath = "./../../home/jkragt/home.nix";
            userSettings = {
                extraGroups = ["wheel"];
            };

        };
    };
}
