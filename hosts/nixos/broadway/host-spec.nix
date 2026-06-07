{
  flake.nixosModules.host-broadway =
    { ... }:
    {
      hostSpec = {
        hostName = "broadway";
        primaryUser = "jkragt";
        role = "server";
        timeZone = "Europe/Amsterdam";
      };
    };
}
