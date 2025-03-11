{ config, outputs, ... }:
{
   home-manager.users = builtins.mapAttrs (
       name: user: {...}: {
               imports = [
                   (import user.homeFilePath)
                   outputs.homeManagerModules.default
               ];
           })
           (config.myNixOS.home-users);

    users.users = builtins.mapAttrs (
        name: user:
        {
            isNormalUser = true;
        }
       // user.userSettings
    ) (config.myNixOS.home-users);
}
