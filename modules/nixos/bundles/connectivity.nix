{
  lib,
  ...
}:
{
  myNixOS.iwd.enable = lib.mkDefault true;
  myNixOS.services.openssh.enable = lib.mkDefault true;
}
