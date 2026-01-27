{
  pkgs,
  ...
}:
{
  programs.keepassxc = {
    enable = true;
    settings = {
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
