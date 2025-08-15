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
  ];

  # Use home.file to create direct links to applications in ~/Applications
  # This ensures they appear in Spotlight and Launchpad
  home.file."Applications/Slack.app" = {
    source = "${pkgs.slack}/Applications/Slack.app";
    recursive = true;
  };

  home.stateVersion = "25.05";
}
