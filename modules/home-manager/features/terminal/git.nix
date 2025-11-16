{
  config,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = config.sops.secrets."git/username".path;
      user.email = config.sops.secrets."git/email".path;
    };
  };
}
