{ ... }:

{
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
    Settings = {
      AutoConnect = true;
    };
  };
}
