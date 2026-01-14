{
  config,
  ...
}:
{
  programs.starship = {
    enable = true;
    enableNushellIntegration = config.my.hm.terminal.starship.enable;
  };
}
