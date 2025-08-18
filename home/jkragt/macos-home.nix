{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [
    # inputs.nixvim.packages.${pkgs.system}.default
    pkgs.tree
    pkgs.neovim
    pkgs.slack
    pkgs.pnpm
    pkgs.nodejs
  ];

  # Use home.file to create direct links to applications in ~/Applications
  # This ensures they appear in Spotlight and Launchpad
  home.file."Applications/Slack.app" = {
    source = "${pkgs.slack}/Applications/Slack.app";
    recursive = true;
  };
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

  home.stateVersion = "25.05";
}
