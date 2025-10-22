{
  pkgs,
  ...
}:
{
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
}