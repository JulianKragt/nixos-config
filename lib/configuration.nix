{
  inputs,
  lib,
  ...
}:
let
  outputs = inputs.self.outputs;
  pkgsWithOverlays = sys: import inputs.nixpkgs {
        system = sys;
        config = {
          allowUnfree = true;
        };
        overlays = import ../overlays { inherit inputs; };
      };
in {
  wsl = config:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      pkgs = pkgsWithOverlays "x86_64-linux";
      specialArgs = {
        inherit inputs outputs lib;
      };
      modules = [
        inputs.nixos-wsl.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        config
        ./../options
        outputs.nixosModules.default
        {
          environment.systemPackages = [
            inputs.home-manager.packages.x86_64-linux.home-manager
          ];
          wsl.enable = true;
          nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
        }
      ];
    };
  darwin = sys: config:
    inputs.darwin.lib.darwinSystem {
      system = sys;
      pkgs = pkgsWithOverlays sys;
      specialArgs = {
        inherit inputs outputs lib;
      };
      modules = [
        config
        ./../options
        outputs.darwinModules.default
        inputs.sops-nix.darwinModules.sops
        {
          environment.systemPackages = [
            inputs.home-manager.packages.x86_64-darwin.home-manager
          ];
          nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
        }
      ];
    };

  home = sys: config:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsWithOverlays sys;
      extraSpecialArgs = {
        inherit inputs outputs;
      };
      modules = [
        config
        ./../options
        ./../modules/shared/sops.nix
        inputs.sops-nix.homeManagerModules.sops
        outputs.homeManagerModules.default
      ];
    };
}
