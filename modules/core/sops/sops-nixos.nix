{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./secrets.nix
  ];

  sops = {
    defaultSopsFile = "${inputs.my-secrets}/secrets.yaml";
    validateSopsFiles = false;

    age = {
      # automatically import host SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # this will use an age key that is expected to already be in the filesystem
      keyFile = "/var/lib/sops-nix/key.txt";
      # generate a new key if the key specified above does not exits
      generateKey = true;
    };

    secrets = {
      "private_keys/jkragt" = {
        path = "/home/jkragt/.ssh/id_ed25519";
        # owner = config.users.users.jkragt.name;
      };
      "public_keys/jkragt" = {
        path = "/home/jkragt/.ssh/id_ed25519.pub";
        # owner = config.users.users.jkragt.name;
      };
    };
  };
}
