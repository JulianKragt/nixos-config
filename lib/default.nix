{ inputs, lib }:
{
  mkConfig = import ./configuration.nix {inherit inputs lib;};
  module = import ./module-extender.nix {inherit lib;};
}
