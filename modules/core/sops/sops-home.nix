{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = "${inputs.my-secrets}/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "private_keys/jkragt" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
      "public_keys/jkragt" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
    };
  };
}
  
