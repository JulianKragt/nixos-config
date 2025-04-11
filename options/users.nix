{ lib, ... }:
{
    options.myNixOS.home-users = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
            options = {
                homeFilePath = lib.mkOption {};
                userSettings = lib.mkOption {
                    default = {};
                };
            };
        });
    };
    options.myMacOS.home-users = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
            options = {
                homeFilePath = lib.mkOption {};
                userSettings = lib.mkOption {
                    default = {};
                };
            };
        });
    };
}
