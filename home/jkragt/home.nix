{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.neofetch
    pkgs.tree
    inputs.julvim.packages.${pkgs.system}.default
  ];

  myHomeManager.hyprland.enable = true;

   programs.git = {
     enable = true;
     userName = "JulianKragt";
     userEmail = "";
   };

  myHomeManager.bundles.desktop-apps.enable = true;
  myHomeManager.kitty.enable = true;
  myHomeManager.fonts.enable = true;   

  # Nicely reload system units when changing configs
#  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
