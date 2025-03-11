{
    description = "Julian Kragt's NixOS configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
        home-manager = {
           url = "github:nix-community/home-manager";
           inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland.url = "github:hyprwm/Hyprland";
    };

    outputs = { ... } @ inputs: let
        lib = inputs.nixpkgs.lib;
        myLib = import ./lib/default.nix {inherit inputs lib;};
    in {
        overlays = import ./overlays {inherit inputs;};

        nixosConfigurations = {
            laptop = myLib.mkSystem ./hosts/laptop/configuration.nix;
        };
        homeConfigurations = {
            "jkragt@laptop" = myLib.mkHome "x86_64-linux" ./home/jkragt/home.nix;
        };

       homeManagerModules.default = ./modules/home-manager;
       nixosModules.default = ./modules/nixos;
    };
}
