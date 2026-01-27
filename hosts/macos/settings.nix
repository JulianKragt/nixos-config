{
  config,
  ...
}:
{
  system.defaults = {
    dock = {
      autohide = false;
      expose-animation-duration = 0.3;
      expose-group-apps = true;
      mineffect = "genie";
      minimize-to-application = true;
      mru-spaces = false;
      # static-only = true;
      tilesize = 48;
      wvous-tr-corner = 2;

      persistent-apps = [
        { app = "/Users/${config.system.primaryUser}/Applications/Home Manager Apps/Firefox.app"; }
        { app = "/Users/${config.system.primaryUser}/Applications/Home Manager Apps/Slack.app"; }
        { app = "/Users/${config.system.primaryUser}/Applications/Home Manager Apps/Spotify.app"; }
        { app = "/Users/${config.system.primaryUser}/Applications/Home Manager Apps/PhpStorm.app"; }
        { app = "/Users/${config.system.primaryUser}/Applications/Home Manager Apps/Ghostty.app"; }
      ];
    };
    finder = {
      _FXShowPosixPathInTitle = true;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXPreferredViewStyle = "clmv";
      NewWindowTarget = "Other";
      NewWindowTargetPath = "/Users/${config.system.primaryUser}/Downloads/";
      ShowExternalHardDrivesOnDesktop = false;
      ShowHardDrivesOnDesktop = false;
      ShowMountedServersOnDesktop = false;
      ShowPathbar = true;
      ShowRemovableMediaOnDesktop = false;
      ShowStatusBar = true;
    };
    menuExtraClock = {
      Show24Hour = true;
      ShowDate = 1;
    };
    screencapture.target = "clipboard";
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    spaces.spans-displays = false;


    WindowManager = {
      GloballyEnabled = true;
      EnableStandardClickToShowDesktop = false;
      EnableTiledWindowMargins = false;
    };
  };


  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
    swapLeftCtrlAndFn = true;
  };
}
