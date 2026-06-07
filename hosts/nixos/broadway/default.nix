{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.broadway = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.host-broadway
    ];
  };

  flake.nixosConfigurations.broadway-bootstrap = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self;
    };
    modules = [ ./bootstrap.nix ];
  };

  flake.nixosModules.host-broadway =
    { ... }:
    {
      imports = [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
      ]
      ++ (with self.nixosModules; [
        host-spec
        core
        host-common
        usersDispatch
        openssh
      ]);
    };
}
