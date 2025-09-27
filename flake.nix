{
  description = "Julian Kragt's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:JulianKragt/nixvim";
  };

  outputs = { ... } @ inputs: let
    lib = inputs.nixpkgs.lib.extend (prev: final: {
      custom = import ./lib { inherit inputs; lib = inputs.nixpkgs.lib; };
    });
  in {
    lib = lib;

    homeConfigurations = {
      "jkragt@macos" = lib.custom.mkConfig.home "x86_64-darwin" ./home/jkragt/macos-home.nix;
    };
    darwinConfigurations = {
      macos = lib.custom.mkConfig.darwin "x86_64-darwin" ./hosts/macos/configuration.nix;
    };

    homeManagerModules.default = ./modules/home-manager;

    nixConfig = {
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
      extra-substituters = [
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
