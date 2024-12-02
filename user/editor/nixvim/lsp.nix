{ ... }:
{
    programs.nixvim.plugins.lsp = {
        enable = true;
        inlayHints = true;
        servers = {
            gleam = {
                enable = true;
                autostart = true;
            };
            nixd = {
                enable = true;
                autostart = true;
            };
        };
    };
}
