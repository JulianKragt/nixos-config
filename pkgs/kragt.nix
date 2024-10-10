{ config, pkgs, ... }:

let
  scriptsDir = config.my.user.settings.dotfilesDir+"/scripts/";
  script = ''
    case "$1" in
      "sync")
          if [ "$#" = 1 ]; then
	    ''+scriptsDir+''sync.sh;
	    exit 0;
	  fi
          case "$2" in
	    "user")
	      ''+scriptsDir+''sync-user.sh;
	      exit 0;
	      ;;
	    "system")
	      ''+scriptsDir+''sync-system.sh;
	      exit 0;
	      ;;
	  esac
        exit 0;
        ;;
    esac	
  ''; 
in
{
  environment.systemPackages = [
    (pkgs.writeScriptBin "kragt" script)
  ];
}
