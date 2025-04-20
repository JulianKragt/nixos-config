{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.myNixOS;

  # Taking all modules in ./features and adding enables to them
  features =
    lib.custom.extendModules
    (name: {
        extraOptions = {
          myNixOS.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
        };

        configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    (lib.custom.listNixFilesRecursive ./features);

  # Taking all module bundles in ./bundles and adding bundle.enables to them
  bundles =
    lib.custom.extendModules
    (name: {
      extraOptions = {
        myNixOS.bundles.${name}.enable = lib.mkEnableOption "enable ${name} module bundle";
      };

      configExtension = config: (lib.mkIf cfg.bundles.${name}.enable config);
    })
    (lib.custom.listNixFilesRecursive ./bundles);

  # Taking all module services in ./services and adding services.enables to them
  services =
    lib.custom.extendModules
    (name: {
      extraOptions = {
        myNixOS.services.${name}.enable = lib.mkEnableOption "enable ${name} service";
      };

      configExtension = config: (lib.mkIf cfg.services.${name}.enable config);
    })
    (lib.custom.listNixFilesRecursive ./services);
in {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ features
    ++ bundles
    ++ services;


  config = {
    nix.settings.experimental-features = ["nix-command" "flakes" "pipe-operators"];
  };
}
