{
  inputs,
  lib,
  ...
}:
let
  outputs = inputs.self.outputs;
in {
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
  darwin = sys: config:
    inputs.darwin.lib.darwinSystem {
      system = sys;
      specialArgs = {
        inherit inputs outputs lib;
      };
      modules = [
        config
        ./../options
        inputs.home-manager.darwinModules.home-manager
        outputs.darwinModules.default
      ];
    };
}
