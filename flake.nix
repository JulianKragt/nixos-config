{

  description = "My first flake";

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      profile = "work";

      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in {
    nixosConfigurations = {
      system = nixpkgs.lib.nixosSystem {
	system = system;
	modules = [
	  ./options
	  ./control-center.nix
	  (./profiles + ("/" + profile) + "/configuration.nix")
	];
	specialArgs = {
	  inherit profile;
	  inherit pkgs-unstable;
	  inherit inputs;
	};
      }; 
    };
    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
	inherit pkgs;
	modules = [
	  ./options
	  ./control-center.nix
	  (./profiles + ("/" + profile) + "/home.nix")
	];
	extraSpecialArgs = {
	  inherit profile;
	  inherit pkgs-unstable;
	  inherit inputs;
	};
      };
    };
  };


  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/Hyprland.git";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

}
