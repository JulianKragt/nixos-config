{
  inputs,
  ...
}:
let
  nixosSops =
    { config, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.default ];

      sops = {
        defaultSopsFile = "${inputs.nix-secrets}/hosts/${config.hostSpec.hostName}.yaml";
        validateSopsFiles = false;
        age = {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          keyFile = "/var/lib/sops-nix/key.txt";
          generateKey = true;
        };
      };
    };

  darwinSops =
    { config, ... }:
    {
      imports = [ inputs.sops-nix.darwinModules.default ];

      sops = {
        defaultSopsFile = "${inputs.nix-secrets}/hosts/${config.hostSpec.hostName}.yaml";
        validateSopsFiles = false;
        age = {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          keyFile = "/var/lib/sops-nix/key.txt";
          generateKey = true;
        };
      };
    };
in
{
  flake.nixosModules.core = nixosSops;
  flake.darwinModules.core = darwinSops;
}
