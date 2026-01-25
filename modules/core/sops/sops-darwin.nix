
{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  sops = {
    defaultSopsFile = "${inputs.my-secrets}/secrets.yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };
}
