{
  config,
  pkgs,
  inputs,
  ...
}:
{
  users.users."jkragt" = {
  };

  environment.systemPackages = [
    pkgs.git
  ];

  my.mac.services.ssh.enable = true;

  system.primaryUser = "jkragt";

  system.stateVersion = 6;
}
