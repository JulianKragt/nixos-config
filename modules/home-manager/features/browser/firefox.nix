{ 
pkgs,
...
}:
{
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" ];
    package = pkgs.firefox-beta-bin;
  };
}
