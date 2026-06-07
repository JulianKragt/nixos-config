{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.atlas = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.host-atlas
    ];
  };

  flake.nixosModules.host-atlas =
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
        fonts
      ]);
    };
}
