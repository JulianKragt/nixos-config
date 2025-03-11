# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  ...
}: {
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

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
