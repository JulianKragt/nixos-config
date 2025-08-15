{
  inputs,
  lib,
  ...
}:
let
  outputs = inputs.self.outputs;
in {
  darwin = sys: config:
    let
      pkgs = import inputs.nixpkgs {
        system = sys;
        config.allowUnfree = true;
      };
    in
    inputs.darwin.lib.darwinSystem {
      system = sys;
      pkgs = pkgs;
      specialArgs = {
        inherit inputs outputs lib;
      };
      modules = [
        config
        ./../options
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
          nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
        }
      ];
    };

  home = sys: config:
    let
      pkgs = import inputs.nixpkgs {
        inherit sys;
        config.allowUnfree = true;
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      extraSpecialArgs = {
        inherit inputs outputs lib;
      };
      modules = [
        config
        ./../options
      ];
    };
}
