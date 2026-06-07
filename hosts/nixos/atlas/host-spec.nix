{
  flake.nixosModules.host-atlas =
    { ... }:
    {
      hostSpec = {
        hostName = "atlas";
        primaryUser = "jkragt";
        role = "workstation";
        timeZone = "Europe/Amsterdam";
      };
    };
}
