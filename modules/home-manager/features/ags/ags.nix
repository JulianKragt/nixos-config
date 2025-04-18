{
  inputs,
  pkgs,
 ...
}:
{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    extraPackages = [
      inputs.ags.packages.${pkgs.system}.battery
      inputs.ags.packages.${pkgs.system}.io
      pkgs.fzf
    ];
  };
  home.file = {
    ".config/ags/config.js".source = ./config/config.js;
    ".config/ags/style.css".source = ./config/style.css;
    ".config/ags/colors_default.css".source = ./config/colors_default.css;
    # ".config/ags/colors.css".source = 
  };
}
