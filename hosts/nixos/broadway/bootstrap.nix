{
  self,
  inputs,
  ...
}:
{
  imports = [
    self.nixosModules.install-spec
    self.nixosModules.openssh
    ./disko.nix
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
  ];

  installSpec = {
    hostName = "broadway";
    primaryUser = "jkragt";
    timeZone = "Europe/Amsterdam";
    generateHardware = true;
    enrollSops = true;
    pushSecrets = true;
    deployFullConfig = true;
  };
}
