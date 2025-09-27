{
  pkgs,
  inputs,
  config,
  ...
}:
{
  home.packages = [
    # inputs.nixvim.packages.${pkgs.system}.default
    pkgs.tree
    pkgs.neovim
    pkgs.pnpm
    pkgs.nodejs
  ];

  # Use home.file to create direct links to applications in ~/Applications
  # This ensures they appear in Spotlight and Launchpad
  home.file."Applications/KeePassXC.app" = {
    source = "${pkgs.keepassxc}/Applications/KeePassXC.app";
    recursive = true;
  };

  programs.keepassxc = {
    enable = true;
    settings = {
      Browser.Enable = true;
      GUI = {
        AdvancedSettings = true;
        ApplicationTheme = "dark";
        CompactMode = true;
        HidePasswords = true;
      };
      SSHAgent.Enabled = true;
    };
  };

  my.hm.obsidian.enable = true;
  my.hm.slack.enable = true;
#  my.hm.services.docker.enable = true;
#  my.hm.qmk.enable = true;
  my.hm.terminal.starship.enable = true;
  my.hm.terminal.nushell.enable = true;
  my.hm.terminal.ghostty.enable = true;

  home.stateVersion = "25.05";
}
