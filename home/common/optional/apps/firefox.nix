{
  flake.homeModules.firefox =
    { inputs, pkgs, hostSpec, ... }:
    let
      inherit (inputs.firefox-addons.lib.${pkgs.stdenv.hostPlatform.system}) buildFirefoxXpiAddon;
      hideShorts = buildFirefoxXpiAddon rec {
        pname = "hide-youtube-shorts";
        version = "1.11.0";
        addonId = "{88ebde3a-4581-4c6b-8019-2a05a9e3e938}";
        url = "https://addons.mozilla.org/firefox/downloads/latest/hide-youtube-shorts/addon.xpi";
        sha256 = "0r9pwvr7hnl9sig83y84gl155a5cgad1nr1m81sv6n740jfkwi0c";
        meta = with pkgs.lib; {
          description = "Hide YouTube Shorts";
          homepage = "https://addons.mozilla.org/en-US/firefox/addon/hide-youtube-shorts/";
          license = licenses.mit;
          platforms = platforms.all;
        };
      };
    in
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
              hideShorts
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
              hideShorts
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
