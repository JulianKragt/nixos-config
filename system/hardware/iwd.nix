{ config, lib, pkgs, ... }:

{
  
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
      Settings = {
        AutoConnect = true;
      };
  };

#   [Security]
#   EAP-Method=PEAP
#   EAP-Identity=anonymous@student.windesheim.nl
#   EAP-PEAP-Phase2-Method=MSCHAPV2
#   EAP-PEAP-Phase2-Identity=......@student.windesheim.nl
#   EAP-PEAP-Phase2-Password=
#
#
#   [Settings]
#   AutoConnect=true
#   AlwaysRandomizeAddress=true
}
