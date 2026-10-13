{
  self,
  inputs,
  ...
}:
{
  imports = [
    self.nixosModules.bootstrap-base
    self.nixosModules.host-atlas-spec
    self.nixosModules.openssh
    ./disko.nix
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
  ];
}
