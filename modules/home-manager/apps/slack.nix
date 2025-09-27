{
  pkgs,
  ...
}: {

  home.packages = [
    pkgs.slack
  ];

  # Use home.file to create direct links to applications in ~/Applications
  # This ensures they appear in Spotlight and Launchpad
  home.file."Applications/Slack.app" = {
    source = "${pkgs.slack}/Applications/Slack.app";
    recursive = true;
  };
}