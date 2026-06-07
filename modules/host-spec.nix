let
  hostSpecModule =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      options.hostSpec = lib.mkOption {
        description = "Typed metadata about this host (set in hosts/<plat>/<host>/host-spec.nix).";
        type = lib.types.submodule {
          options = {
            hostName = lib.mkOption {
              type = lib.types.str;
              description = "The host's network name (also `networking.hostName` on NixOS).";
            };

            primaryUser = lib.mkOption {
              type = lib.types.str;
              description = ''
                The primary admin user of this host. Must have a corresponding
                home/<primaryUser>/<hostName>.nix file or evaluation will fail.
              '';
            };

            home = lib.mkOption {
              type = lib.types.str;
              description = "Home directory of the primary user.";
              default =
                let
                  u = config.hostSpec.primaryUser;
                in
                if pkgs.stdenv.isDarwin then "/Users/${u}" else "/home/${u}";
            };

            role = lib.mkOption {
              type = lib.types.enum [
                "workstation"
                "server"
                "wsl"
              ];
              default = "workstation";
              description = "High-level host role; gates a few feature defaults.";
            };

            persistFolder = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "If impermanence is enabled, the persisted root (e.g. /persist).";
            };

            timeZone = lib.mkOption {
              type = lib.types.str;
              default = "Europe/Amsterdam";
              description = "IANA timezone (used by both NixOS and HM).";
            };

            stateVersion = lib.mkOption {
              type = lib.types.str;
              default = "25.11";
              description = "system.stateVersion / home.stateVersion baseline.";
            };

            useYubikey = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Indicate this host uses a YubiKey (gates feature wiring).";
            };
          };
        };
      };

      config.assertions = [
        {
          assertion = builtins.pathExists (
            ../home + "/${config.hostSpec.primaryUser}/${config.hostSpec.hostName}.nix"
          );
          message = ''
            hostSpec.primaryUser = "${config.hostSpec.primaryUser}" 

              { self, ... }:
              {
                flake.homeModules."${config.hostSpec.primaryUser}-${config.hostSpec.hostName}" =
                  { ... }: {
                  };
              }
          '';
        }
      ];
    };
in
{
  flake.nixosModules.host-spec = hostSpecModule;
  flake.darwinModules.host-spec = hostSpecModule;
}
