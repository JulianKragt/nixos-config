{
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.account-secrets =
    { config, ... }:
    {
      sops.secrets = lib.listToAttrs (
        map (u: {
          name = "passwords/${u}";
          value = {
            sopsFile = "${inputs.nix-secrets}/users/${u}.yaml";
            key = "hashedPassword";
            neededForUsers = true;
          };
        }) config.accounts.activeUsers
      );
    };

  flake.darwinModules.account-secrets = {};
}
