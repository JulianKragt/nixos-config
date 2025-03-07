{
    description = "Julian Kragt's NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manger = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outpusts = {...} @ inputs: let
        myLib = import ./lib/default.nix {inherit inputs;};
    in {
        nixosConfigruations = {
            laptop = myLib.mkSystem ./hosts/laptop/configuration.nix;
        };
        homeConfigruations = {
            "jkragt@laptop" = myLib.mkHome "x86_64-linux" ./home/jkragt/home.nix;
        };

        homeManagerModules.default = ./modules/home-manager;
        nixosModules.default = ./modules/nixos;
    };
}
