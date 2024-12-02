{
  description = "My first flake";

  outputs = { self, nixpkgs, home-manager, nixvim, kmonad, ... }@inputs:
    let
      system = "x86_64-linux";
      profile = "work";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
    nixosConfigurations = {
      system = nixpkgs.lib.nixosSystem {
	system = system;
	modules = [
	  ./options
	  ./control-center.nix
	  ./pkgs/kragt.nix
	  (./profiles + ("/" + profile) + "/configuration.nix")
	  kmonad.nixosModules.default
	];
	specialArgs = {
	  inherit profile;
	  inherit inputs;
	};
      }; 
    };
    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
	modules = [
	  ./options
	  ./control-center.nix
	  inputs.stylix.homeManagerModules.stylix
	  (./profiles + ("/" + profile) + "/home.nix")
          nixvim.homeManagerModules.nixvim
	];
	extraSpecialArgs = {
	  inherit profile;
	  inherit inputs;
	};
      };
    };
  };


  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    stylix.url = "github:danth/stylix";

    hyprland = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/Hyprland.git";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    kmonad = {
      url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

}
