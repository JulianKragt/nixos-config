{ pkgs, ... }:
{
    programs.nixvim.plugins.treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            bash
            json
            markdown
            nix
            regex
            toml
            vim
            vimdoc
            xml
            yaml
        ];

        settings = {
            auto_install = true;

            indent.enable = true;

            highlight = {
                enable = true;
            };

            incremental_selection = {
                enable = true;
                keymaps = {
                    init_selection = "<leader>ss";
                    node_incremental = "<leader>si";
                    scope_incremental = "<leader>sc";
                    node_decremental = "<leader>sd";
                };
            };
        };

        nodejsPackage = null;
    };

    programs.nixvim.plugins.treesitter-textobjects = {
        enable = true;

        select = {
            enable = true;
            lookahead = true;
            includeSurroundingWhitespace = true;

            keymaps = {
                "af".query = "@function.outer";
                "if".query = "@function.inner";
                "ac".query = "@class.outer";
                "ic".query = "@class.inner";
                "as" = {
                    query = "@scope";
                    queryGroup = "locals";
                };
            };

            selectionModes = {
                "@function.outer" = "v";
            };
        };
    };
}
