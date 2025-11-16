{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [
    inputs.nixvim.packages.${pkgs.system}.default
    pkgs.tree
  ]; 

  my.hm.terminal.git.enable = true;
  my.hm.services.ssh.enable = true;

  home.username = "jkragt";
  home.homeDirectory = "/home/jkragt";
  home.stateVersion = "25.11";
}
