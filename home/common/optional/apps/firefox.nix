{
  flake.homeModules.firefox =
    { inputs, pkgs, hostSpec, ... }:
    {
      programs.firefox = {
        enable = true;
        package = pkgs.stable.firefox;
        profiles = {
          work = {
            name = "work";
            id = 0;
            isDefault = hostSpec.hostName == "workhorse";
            extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
              bitwarden
              ublock-origin
              sponsorblock
              youtube-shorts-block
            ];
            settings = {
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.bookmarks.addedImportButton" = false;
              "browser.toolbars.bookmarks.visibility" = "always";
              "browser.contextual-password-manager.enabled" = false;
            };
            bookmarks = {
              force = true;
              settings = [
                {
                  toolbar = true;
                  bookmarks = [
                    {
                      name = "";
                      url = "localhost:1841";
                    }
                    {
                      name = "";
                      url = "localhost:1843";
                    }
                    {
                      name = "";
                      url = "https://w3worx.atlassian.net/jira/software/c/projects/APPR/boards/8/backlog?assignee=712020%3Ac6c8b59d-932f-4ea0-ace6-a668b9159412";
                    }
                    {
                      name = "";
                      url = "https://bitbucket.org/w3worxdevelopers/appreo/pull-requests/";
                    }
                    {
                      name = "DB";
                      url = "https://phpmyadmin.test";
                    }
                    {
                      name = "Live DB";
                      url = "https://phpmyadmin.appreo.app:8888/phpmyadmin/index.php?route=/";
                    }
                    {
                      name = "";
                      url = "https://www.chatgpt.com";
                    }
                  ];
                }
              ];
            };
          };
          cove = {
            name = "cove";
            id = 1;
            isDefault = false;
            extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
              bitwarden
              ublock-origin
              sponsorblock
              youtube-shorts-block
            ];
            settings = {
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.bookmarks.addedImportButton" = false;
              "browser.toolbars.bookmarks.visibility" = "always";
              "browser.contextual-password-manager.enabled" = false;
            };
            bookmarks = {
              force = true;
              settings = [
                {
                  toolbar = true;
                  bookmarks = [
                    {
                      name = "teams";
                      url = "localhost:1841";
                    }
                    {
                      name = "outlook";
                      url = "localhost:1843";
                    }
                    {
                      name = "odoo";
                      url = "https://w3worx.atlassian.net/jira/software/c/projects/APPR/boards/8/backlog?assignee=712020%3Ac6c8b59d-932f-4ea0-ace6-a668b9159412";
                    }
                    {
                      name = "github";
                      url = "https://bitbucket.org/w3worxdevelopers/appreo/pull-requests/";
                    }
                  ];
                }
              ];
            };
          };
        };
      };
    };
}
