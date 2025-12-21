{
  sops.secrets = {
    "git/username" = {};
    "git/email" = {};
    # "git/work/username" = {};
    # "git/work/email" = {};
    "private_keys/jkragt" = {
      path = "/home/jkragt/.ssh/id_ed25519";
    };
    "public_keys/jkragt" = {
      path = "/home/jkragt/.ssh/id_ed25519.pub";
    };
  };
}
