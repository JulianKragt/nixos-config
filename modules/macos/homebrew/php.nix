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
  ];

  environment.systemPackages = [
    pkgs.libmemcached
  ];

  environment.systemPath = [
    "$HOME/.config/composer/vendor/bin"
  ];

  system.activationScripts.memcachedextension = {
    enable = true;
    text = ''
      #!/usr/bin/env bash
      set -e
     
      echo "=== memcached activation running ==="
     
      # Only install if missing
      if ! php -m | grep -q memcached; then
        echo "Installing PHP memcached extension via PECL..."
     
        # Run PECL install with explicit configure flags
        pecl install -f memcached -- \
          --with-php-config=/opt/homebrew/opt/php@8.3/bin/php-config \
          --with-libmemcached-dir=${pkgs.libmemcached} \
          --with-zlib-dir=no \
          --with-system-fastlz=no \
          --enable-memcached-igbinary=no \
          --enable-memcached-msgpack=no \
          --enable-memcached-json=no \
          --enable-memcached-protocol=no \
          --enable-memcached-sasl=yes \
          --enable-memcached-session=yes
      else
        echo "memcached PHP extension already installed"
      fi
    '';
  };
}
