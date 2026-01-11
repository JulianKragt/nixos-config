{
  config,
  pkgs,
  ...
}:
{
  system.stateVersion = "25.11";
  environment.systemPackages = with pkgs; [
    curl 
    wget 
    age
    sops
  ];

  my.nix.services.ssh.enable = true;

  sops.secrets."jkragt-password"= {};
  sops.secrets."jkragt-password".neededForUsers = true;
  users.mutableUsers = false;

  users.users."jkragt" = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."jkragt-password".path;
    extraGroups = [ "wheel" ];
  };
  wsl.defaultUser = "jkragt";
}
