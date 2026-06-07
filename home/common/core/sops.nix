{
  flake.homeModules.core =
    { config, inputs, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops = {
        defaultSopsFile = "${inputs.nix-secrets}/users/${config.home.username}.yaml";
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        validateSopsFiles = false;

        secrets."ssh/private_key" = {
          key = "ssh/private_key";
          path = "${config.home.homeDirectory}/.ssh/id_ed25519";
          mode = "0600";
        };

        secrets."ssh/public_key" = {
          key = "ssh/public_key";
          path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
          mode = "0644";
        };
      };
    };
}
