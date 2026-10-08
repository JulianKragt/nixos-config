{
  flake.homeModules.core =
    { config, inputs, hostSpec, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops = {
        defaultSopsFile = "${inputs.nix-secrets}/host-users/${hostSpec.hostName}-${config.home.username}.yaml";
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        validateSopsFiles = false;

      };
    };
}
