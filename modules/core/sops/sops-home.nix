{
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./secrets.nix
  ];

  sops = {
    # This is the jkragt/dev key and needs to be copyed to this location on the host
    age.keyFile = "/home/jkragt/.config/sops/age/keys.txt";

    defaultSopsFile = "${inputs.my-secrets}/secrets.yaml";
    validateSopsFiles = false;

  };
}
  
