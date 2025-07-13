{ config, lib, pkgs, options, attrs, outputs, inputs, ... }:

let
  loader = lib.custom.module-loader {
    inherit lib pkgs config options attrs outputs inputs;
    moduleDir = ./features;
    group = "myMacOS";
    configPath = config.myMacOS;
  };
in
{
  options = loader.options;
  imports = loader.modules;

  # Any other config here...
  config.nix.settings.experimental-features = ["nix-command" "flakes" "pipe-operators"];
}
