{
  pkgs,
  ...
}:
{
  system.stateVersion = "25.11";
  environment.systemPackages = with pkgs; [ curl wget ];

  users.users."jkragt" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  wsl.defaultUser = "jkragt";
}
