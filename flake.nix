{
    description = "Julian Kragt's NixOS configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
           url = "github:nix-community/home-manager";
           inputs.nixpkgs.follows = "nixpkgs";
        };
       nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
        };

       homeManagerModules.default = ./modules/home-manager;
       nixosModules.default = ./modules/nixos;
    };
}
