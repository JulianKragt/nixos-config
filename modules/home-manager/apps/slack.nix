{
  pkgs,
  ...
}: {

  home.packages = [
    pkgs.slack
  ];

# home.file."Applications/Slack.app" = {
#   source = "${pkgs.slack}/Applications/Slack.app";
#   recursive = true;
# };
}
