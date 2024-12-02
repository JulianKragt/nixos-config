{ config, ... }:

{

  imports = [
    ./options.nix
    ./colorscheme.nix
    ./treesitter.nix
    ./lsp.nix
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = (config.my.user.settings.editor == "neovim");

    performance = {
      combinePlugins = {
        enable = true;
        standalonePlugins = [
          "hmts.nvim"
          "nvim-treesitter"
        ];
      };
      byteCompileLua.enable = true;
    };

    vimdiffAlias = true;
    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
  };
}
