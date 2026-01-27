{ config, pkgs, lib, ... }:

{
  programs.onedrive.enable = lib.mkIf pkgs.stdenv.hostPlatform.isLinux true;
}

