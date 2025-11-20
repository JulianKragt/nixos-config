{
  pkgs,
  inputs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    package = inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
