{
  description = "Julian Kragt's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "github:hyprwm/Hyprland";
    nixvim.url = "github:JulianKragt/nixvim";
    ags.url = "github:aylur/ags";
  };

  outputs = { ... } @ inputs: let
    lib = inputs.nixpkgs.lib.extend(prev: final: { custom = (import ./lib inputs); } // inputs.home-manager.lib);
  in {
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      laptop = lib.custom.mkConfig.nixos ./hosts/laptop/configuration.nix;
    };
    homeConfigurations = {
      "jkragt@laptop" = lib.custom.mkConfig.home "x86_64-linux" ./home/jkragt/home.nix;
      "jkragt@macos" = lib.custom.mkConfig.home "x86_64-darwin" ./home/jkragt/macos-home.nix;
    };
    darwinConfigurations = {
      macos = lib.custom.mkConfig.darwin "x86_64-darwin" ./hosts/macos/configuration.nix;
    };

    homeManagerModules.default = ./modules/home-manager;
    nixosModules.default = ./modules/nixos;
    darwinModules.default = ./modules/macos;
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
