{ inputs, lib }:

{
  module-loader = args: import ./module-loader.nix (args // { inherit inputs; });
}
