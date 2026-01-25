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
#    {
#      path = ./features;
#      prefix = [ "my" "mac" ];
#    }
#    {
#      path = ./apps;
#      prefix = [ "my" "mac" ];
#    }
    {
      path = ./services;
      prefix = [ "my" "mac" "services" ];
    }
    {
      path = ./homebrew;
      prefix = [ "my" "mac" "homebrew" ];
    }
    ]
    args;
}
