{
  self,
  inputs,
  ...
}:
{
  imports = [
    self.nixosModules.bootstrap-base
    self.nixosModules.host-broadway-spec
    self.nixosModules.openssh
    ./disko.nix
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
  ];
}
