{
  lib,
  config,
  inputs,
  pkgs,
  ...
} @ args:
{
  imports = (import ../../lib/module-extender.nix { inherit lib; }).extend
    ({ info, module }: {
      options = info.options // (lib.setAttrByPath (info.namespace ++ ["enable"]) (lib.mkEnableOption "enable ${info.dotted} configuration"));
      config = lib.mkIf
        (lib.attrByPath (info.namespace ++ ["enable"]) false config)
        info.config;
    })
    [
    {
      path = ./features;
      prefix = [ "my" "hm" ];
    }
    {
      path = ./apps;
      prefix = [ "my" "hm" ];
    }
    {
      path = ./services;
      prefix = [ "my" "hm" "services" ];
    }
    {
      path = ./bundles;
      prefix = [ "my" "hm" "bundles" ];
    }
    ]
    args;
}
