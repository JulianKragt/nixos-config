{
  flake.nixosModules.core =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      networking.hostName = config.hostSpec.hostName;
      time.timeZone = config.hostSpec.timeZone;

      networking.useDHCP = lib.mkDefault true;
      networking.firewall.enable = lib.mkDefault true;

      boot.tmp.cleanOnBoot = lib.mkDefault true;

      users.mutableUsers = false;

      environment.systemPackages = with pkgs; [
        curl
        git
        just
      ];

      system.stateVersion = config.hostSpec.stateVersion;
    };
}
