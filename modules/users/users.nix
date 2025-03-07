{ config, outputs, ... }:
{
    home-manager = {
        users = 
            builtins.mapAttr (name: user: {...}: {
                imports = [
                    (import user.homeFilePath)
                    outputs.homeManagerModules.default
                ];
            })
            (config.myNixOS.home-users);
    };

    users.users = builtins.mapAttr (
        name: user:
        {
            isNormalUser = true;
            initialPassword = "123456";
        }
       // user.userSettings
    ) (config.myNixOS.home-users);
}
