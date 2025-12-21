{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [
    pkgs.tree
  ]; 

  my.hm.terminal.git.enable = true;
  my.hm.terminal.nushell.enable = true;
  my.hm.services.ssh.enable = true;
  my.hm.IDE.neovim.enable = true;

  home.username = "jkragt";
  home.homeDirectory = "/home/jkragt";
  home.stateVersion = "25.11";
}
