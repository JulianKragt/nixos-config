{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.dejavu-sans-mono
  ];

  fonts.fontconfig.enable = true;
}
