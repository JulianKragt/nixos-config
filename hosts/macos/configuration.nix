{
  pkgs,
  inputs,
  ...
}:
{
  users.users."jkragt" = {
  };

#  my.mac.php83.enable = true;

  system.primaryUser = "jkragt";

  system.stateVersion = 6;
}