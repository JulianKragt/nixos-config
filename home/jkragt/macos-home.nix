{
  pkgs,
  ...
}:
{
  myHomeManager.nushell.enable = true;
  myHomeManager.firefox.enable = true;

  home.stateVersion = "24.11";
}