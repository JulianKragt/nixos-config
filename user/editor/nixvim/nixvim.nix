{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = (config.my.user.settings.editor == "neovim");
    vimdiffAlias = true;
    viAlias = true;
    vimAlias = true;
  };
}
