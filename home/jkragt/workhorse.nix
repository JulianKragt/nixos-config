{ self, ... }:
{
  flake.homeModules.jkragt-workhorse =
    { pkgs, ... }:
    {
      imports =
        with self.homeModules;
        [
          chrome
          bruno
          cursor
          firefox
          ghostty
          keepassxc
          nixvim
          phpstorm
          slack
          spotify
          obsidian
          desktop-aerospace
          docker
          zoxide
          zsh
          starship
        ];

      home.packages = [
        pkgs.claude-code
      ];

      programs.git = {
        settings.user = {
          name = "Julian Kragt";
          email = "18495180+JulianKragt@users.noreply.github.com";
        };
        includes = [
          {
            condition = "gitdir:~/projects/appreo/";
            contents.user = {
              name = "Julian Kragt";
              email = "julian@w3worx.nl";
            };
          }
        ];
      };

      programs.keepassxc.enable = true;
    };
}
