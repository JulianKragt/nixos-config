{
  config,
  ...
}:
{
  sops.secrets = {
    "git/username" = {};
    "git/email" = {};
    # "git/work/username" = {};
    # "git/work/email" = {};
    "private_keys/jkragt" = {
      path = "/home/jkragt/.ssh/id_ed25519";
      owner = config.users.users.jkragt.name;
    };
    "public_keys/jkragt" = {
      path = "/home/jkragt/.ssh/id_ed25519.pub";
      owner = config.users.users.jkragt.name;
    };
  };
}
