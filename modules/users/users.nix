{
  config,
  pkgs,
  outputs,
  lib,
  ...
}:
{
  users.users = builtins.mapAttrs (
    name: user:
    {
      name = name;
      isNormalUser = lib.mkDefault true;
    }
    // user.userSettings
    // (if pkgs.stdenv.isDarwin then {home = "/Users/${name}";} else {})
  ) config.my.users;
}
