{
  pkgs,
  inputs,
  config,
  ...
}:
{
  home.packages = [
    inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.tree
  ];

  my.hm.firefox.enable = true;
  my.hm.slack.enable = true;
  my.hm.keepass.enable = true;
  my.hm.spotify.enable = true;
#  my.hm.services.docker.enable = true;
#  my.hm.services.direnv.enable = true;
#  my.hm.devenv.enable = true;
#  my.hm.PL.php83.enable = true;
#  my.hm.qmk.enable = true;
#  my.hm.terminal.starship.enable = true;
  my.hm.terminal.nushell.enable = true;
  my.hm.terminal.ghostty.enable = true;
  my.hm.services.percona.enable = true;
#  my.hm.IDE.neovim.enable = true;

  home.stateVersion = "25.11";
  home.username = "jkragt";
   home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/jkragt"
    else "/home/jkragt";

}
