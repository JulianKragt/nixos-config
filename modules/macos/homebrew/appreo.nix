{
  pkgs,
  ...
}:
{
  homebrew.brews = [
    { 
      name = "php@8.3";
      link = true;
    }
    { 
      name = "composer";
      link = true;
    }
    "pkg-config"
  ];

  homebrew.casks = [
    "sencha"
  ];

  environment.systemPackages = [
    pkgs.libmemcached
    pkgs.zlib
  ];

  environment.systemPath = [
    "$HOME/.config/composer/vendor/bin"
    "/opt/Sencha/Cmd"
  ];

system.activationScripts.postActivation.text = ''
  if ! /opt/homebrew/opt/php@8.3/bin/php -m | grep -q memcached; then
    printf -- "----------------------------------------------------------------\n"
    printf -- "PHP memcached is missing. Copy and paste this command to fix it:\n\n"
    
    # Using -- here ensures the nested dashes don't break the activation script
    printf -- "printf \"${pkgs.libmemcached}\\n${pkgs.zlib.dev}\\nno\\nno\\nno\\nno\\nno\\nno\\nyes\\nyes\\n\" | /opt/homebrew/opt/php@8.3/bin/pecl install -f memcached\n\n" 

    printf -- "----------------------------------------------------------------\n"
  fi
'';
}
