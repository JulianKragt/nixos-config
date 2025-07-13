{ config, lib, pkgs, options, attrs, outputs, inputs, ... }:

let
  loader = lib.custom.module-loader {
    inherit lib pkgs config options attrs outputs inputs;
    moduleDir = ./features;
    group = "myHomeManager";
    configPath = config.myHomeManager or {};
  };
in
{
  options = loader.options;
  imports = loader.modules;
}
