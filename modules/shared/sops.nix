{
  config,
  ...
}:
{
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.keyFile = "${config.home.homeDirectory}/.age-key.txt";
  sops.age.generateKey = true;

  sops.secrets."git/username"= {};
  sops.secrets."git/email"= {};
}
