{
  pkgs,
  inputs,
  config,
  ...
}:
{
  my.hm.bundles.workapps.enable = true;
  my.hm.firefox.enable = true;
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
  my.hm.services.memcached.enable = true;
  my.hm.IDE.neovim.enable = true;

  home.stateVersion = "25.11";
  home.username = "jkragt";
  home.homeDirectory = "/Users/jkragt";
}
