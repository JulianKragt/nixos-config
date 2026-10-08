let
  accountsDir = ../hosts/common/accounts;

  installSpecModule =
    {
      self,
      lib,
      config,
      ...
    }:
    {
      options.installSpec = lib.mkOption {
        description = "Install-time settings for nixos-anywhere bootstrap (set in hosts/nixos/<host>/bootstrap.nix).";
        type = lib.types.submodule {
          options = {
            hostName = lib.mkOption {
              type = lib.types.str;
              description = "Host network name during bootstrap install.";
            };

            primaryUser = lib.mkOption {
              type = lib.types.str;
              description = "Used for deploy pre-checks and root SSH authorized keys (primary user key dir).";
            };

            timeZone = lib.mkOption {
              type = lib.types.str;
              default = "Europe/Amsterdam";
              description = "IANA timezone for bootstrap system.";
            };

            stateVersion = lib.mkOption {
              type = lib.types.str;
              default = "25.11";
              description = "system.stateVersion during bootstrap.";
            };

            generateHardware = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Run nixos-anywhere --generate-hardware-config.";
            };

            hardwareConfigPath = lib.mkOption {
              type = lib.types.str;
              default = "hardware-configuration.nix";
              description = "Hardware config filename relative to hosts/nixos/<host>/.";
            };

            enrollSops = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enroll host SSH key in nix-secrets after first boot.";
            };

            provisionUserAgeKey = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Before the full deploy, stream the operator age identity
                (SOPS_AGE_KEY_FILE or ~/.config/sops/age/keys.txt) to the target
                so sops-nix can decrypt host-users/<hostName>-<primaryUser>.yaml for passwords
                and Home Manager secrets. Requires the identity to match
                &user_<primaryUser> in nix-secrets/.sops.yaml.
              '';
            };

            pushSecrets = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Push nix-secrets commits to remote after enrollment.";
            };

            deployFullConfig = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Remote nixos-rebuild switch with full flake output after SOPS.";
            };

            nixSecretsPath = lib.mkOption {
              type = lib.types.str;
              default = "../nix-secrets";
              description = "Path to nix-secrets repo";
            };

            sshWaitTimeout = lib.mkOption {
              type = lib.types.int;
              default = 600;
              description = "Seconds to wait for SSH after reboot.";
            };

            luksPasswordFile = lib.mkOption {
              type = lib.types.str;
              default = "/tmp/disko-password";
              description = "Remote path where disko reads the LUKS passphrase.";
            };

            nixosAnywhereExtra = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Extra flags passed to nixos-anywhere.";
            };
          };
        };
      };

      config = {
        networking.hostName = config.installSpec.hostName;
        time.timeZone = config.installSpec.timeZone;
        system.stateVersion = config.installSpec.stateVersion;

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        users.users.root.openssh.authorizedKeys.keys =
          self.lib.custom.genPubKeyList (accountsDir + "/${config.installSpec.primaryUser}/keys")
          ++ self.lib.custom.genPubKeyList (accountsDir + "/super/keys");
      };
    };
in
{
  flake.nixosModules.install-spec = installSpecModule;
}
