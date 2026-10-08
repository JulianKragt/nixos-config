{
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.account-secrets =
    { config, ... }:
    let
      # Staged by install-host.sh before the first full deploy. Copied into the
      # user home after accounts exist and before Home Manager activation.
      pendingAgeKeyDir = "/var/lib/sops-nix/pending-user-age-keys";
    in
    {
      sops.secrets = lib.listToAttrs (
        map (u: {
          name = "passwords/${u}";
          value = {
            sopsFile = "${inputs.nix-secrets}/host-users/${config.hostSpec.hostName}-${u}.yaml";
            key = "hashedPassword";
            neededForUsers = true;
          };
        }) config.accounts.activeUsers
      );

      # Runs during nixos-rebuild activationScripts (before HM systemd units).
      # isNormalUser primary group matches the username.
      system.activationScripts.sopsUserAgeKeys = {
        deps = [ "users" ];
        text = lib.concatMapStrings (u: ''
          pending="${pendingAgeKeyDir}/${u}"
          dest="/home/${u}/.config/sops/age/keys.txt"
          if [ -f "$pending" ]; then
            install -d -m 0700 -o ${u} -g ${u} "/home/${u}/.config"
            install -d -m 0700 -o ${u} -g ${u} "/home/${u}/.config/sops"
            install -d -m 0700 -o ${u} -g ${u} "/home/${u}/.config/sops/age"
            install -m 0600 -o ${u} -g ${u} "$pending" "$dest"
            rm -f "$pending"
            rmdir "${pendingAgeKeyDir}" 2>/dev/null || true
          fi
        '') config.accounts.activeUsers;
      };
    };

  flake.darwinModules.account-secrets = { };
}
