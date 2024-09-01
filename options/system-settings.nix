{ config, lib, pkgs, ... }:

{
  options.my.system.settings = {
    system = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "x86_64-linux";
    };
    hostname = lib.mkOption {
      type = lib.types.nonEmptyStr;
    };
    profile = lib.mkOption {
      type = lib.types.enum [ "work" ];
      description = "Set which profile to use";
    };
    timezone = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "Europe/Amsterdam";
    };
    locale = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "en_US.UTF-8";
    };
    dualBoot = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    cpuType = lib.mkOption {
      type = lib.types.enum [ "amd" "intel" ];
    };
    gpuType = lib.mkOption {
      type = lib.types.enum [ "nvidia" "amd" "intel" ];
    };
  };
}
