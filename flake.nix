{
  description = "Julian Kragt's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixvim.url = "github:JulianKragt/nixvim";
    sops-nix.url = "github:Mic92/sops-nix";
    my-secrets = {
      url = "git+ssh://git@github.com/JulianKragt/nix-secrets.git?ref=master&shallow=1";
      flake = false;
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {  ... } @ inputs: let
    lib = inputs.nixpkgs.lib.extend (prev: final: {
      custom = import ./lib { inherit inputs; lib = inputs.nixpkgs.lib; };
    });
  in {
    lib = lib;

    nixosConfigurations = {
      wsl = lib.custom.mkConfig.wsl ./hosts/wsl/configuration.nix;
    };

    homeConfigurations = {
      "jkragt@macos" = lib.custom.mkConfig.home "aarch64-darwin" ./home/jkragt/macos-home.nix;
      "jkragt@wsl" = lib.custom.mkConfig.home "x86_64-linux" ./home/jkragt/wsl-home.nix;
    };
    darwinConfigurations = {
      macos = lib.custom.mkConfig.darwin "aarch64-darwin" ./hosts/macos/configuration.nix;
    };

    nixosModules.default = ./modules/nixos;
    darwinModules.default = ./modules/macos;
    homeManagerModules.default = ./modules/home-manager;

    nixConfig = {
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"

      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
      trusted-users = [ "root" "jkragt" ];
    };
  };
}
