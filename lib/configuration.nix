{
  inputs,
  lib,
  ...
}:
let
  outputs = inputs.self.outputs;
in {
  wsl = config:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs outputs lib;
      };
      modules = [
        inputs.nixos-wsl.nixosModules.default
        config
        ./../options
        (builtins.path "/etc/nixos/hardware-configuration.nix")
        outputs.nixosModules.default
        {
          wsl.enable = true;
        }
      ];
    };
  darwin = sys: config:
    let
      pkgs = import inputs.nixpkgs {
        system = sys;
        config = {
          allowUnfree = true;
        };
        overlays = import ../overlays { inherit inputs; };
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
        outputs.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs outputs;
            };
          };
          nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
        }
      ];
    };

  home = sys: config:
    let
      pkgs = import inputs.nixpkgs {
        system = sys;
        config = {
          allowUnfree = true;
        };
        overlays = import ../overlays { inherit inputs; };
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
