{ lib, ... }:
{
    options.myNixOS.home-users = lib.mkOption {
        type = lib.types.attrOf (lib.types.submodule {
            options = {
                homeFilePath = lib.mkOption {};
                userSettings = lib.mkOption {
                    default = {};
                };
            };
        });
    };
}
