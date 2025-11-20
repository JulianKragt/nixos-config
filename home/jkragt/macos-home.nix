{
  pkgs,
  inputs,
  config,
  ...
}:
{
  home.packages = [
    inputs.nixvim.packages.${pkgs.system}.default
    pkgs.tree
    pkgs.pnpm
    pkgs.nodejs
  ];

#  my.hm.obsidian.enable = true;
#  my.hm.slack.enable = true;
#  my.hm.keepass.enable = true;
  my.hm.services.docker.enable = true;
#  my.hm.services.direnv.enable = true;
#  my.hm.devenv.enable = true;
#  my.hm.PL.php83.enable = true;
#  my.hm.qmk.enable = true;
#  my.hm.terminal.starship.enable = true;
#  my.hm.terminal.nushell.enable = true;
#  my.hm.terminal.ghostty.enable = true;
#  my.hm.IDE.neovim.enable = true;


  targets.darwin.copyApps.enable = false;

  home.stateVersion = "25.11";
  home.username = "jkragt";
  home.homeDirectory = "/Users/jkragt";
}
