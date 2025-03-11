{
  inputs,
  lib,
  ...
}:
let
  outputs = inputs.self.outputs;
in rec {
  nixos = config:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs lib;
      };
      modules = [
        config
        ./../options
        outputs.nixosModules.default
      ];
    };
   home = sys: config:
     inputs.home-manager.lib.homeManagerConfiguration {
       pkgs = inputs.nixpkgs.legacyPackages.${sys};
       extraSpecialArgs = {
         inherit inputs outputs lib;
       };
       modules = [
         config
         ./../options
         outputs.homeManagerModules.default
       ];
     };
}
