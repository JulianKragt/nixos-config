{
  config,
  outputs,
  ...
}:
{
   home-manager.users = builtins.mapAttrs (
       name: user: {
               imports = [
                   (import user.homeFilePath)
                    outputs.homeManagerModules.default
               ];
           })
           (config.myMacOS.home-users);

   users.users = builtins.mapAttrs (
       name: user:
       {
         name = name;
         home = "/Users/${name}";
       }
      // user.userSettings
   ) (config.myMacOS.home-users);
}