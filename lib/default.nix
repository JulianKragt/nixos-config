{ inputs, lib }:
{
  mkConfig = import ./configuration.nix {inherit inputs lib;};
}
