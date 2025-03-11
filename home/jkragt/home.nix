# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.neofetch
    pkgs.tree
  ];

#  myHomeManager.hyprland.enable = true;

   programs.git = {
     enable = true;
     userName = "JulianKragt";
     userEmail = "";
   };

   

  # Nicely reload system units when changing configs
#  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
