{
  pkgs,
  inputs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    package = inputs.nixvim.packages.${pkgs.system}.default;
    vimAlias = true;
    vimdiffAlias = true;
  };
}