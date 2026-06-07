# Appreo project: Homebrew formulae/casks and PHP memcached reminder on workhorse.
{
  pkgs,
  config,
  ...
}:
let
  appreoSocket = "/tmp/appreo-pc.sock";
  appreoConfig = pkgs.writeText "appreo-process-compose.yaml" ''
    version: "0.5"
    processes:
      desktop:
        command: "sencha app watch"
        working_dir: "${config.hostSpec.home}/projects/appreo/desktop"
      app:
        command: "sencha app watch --port=1843"
        working_dir: "${config.hostSpec.home}/projects/appreo/app"
      backoffice:
        command: "pnpm run dev"
        working_dir: "${config.hostSpec.home}/projects/appreo/backoffice"
      horizon:
        command: "php artisan horizon"
        working_dir: "${config.hostSpec.home}/projects/appreo/api"
  '';
in
{
  homebrew.enable = true;

  homebrew.brews = [
    {
       name = "php@8.3";
       link = true;
     }
    {
      name = "composer";
      link = true;
    }
    "percona-server"
    "memcached"
    "pkg-config"
    "rabbitmq"
    "redis"
  ];

  homebrew.casks = [
    "sencha"
    "warp"
  ];

  environment.systemPackages = [
    pkgs.libmemcached
    pkgs.autoconf
    pkgs.automake
    pkgs.libtool
    pkgs.code-cursor
    pkgs.zlib
    pkgs.pnpm
    pkgs.process-compose
    (pkgs.writeShellScriptBin "watch-appreo" ''
      exec ${pkgs.process-compose}/bin/process-compose \
        --config ${appreoConfig} \
        --use-uds \
        --unix-socket ${appreoSocket} \
        up "$@"
    '')
    (pkgs.writeShellScriptBin "stop-appreo" ''
      exec ${pkgs.process-compose}/bin/process-compose \
        --use-uds \
        --unix-socket ${appreoSocket} \
        down
    '')
  ];

  environment.systemPath = [
    "${config.homebrew.prefix}/bin"
    "${config.hostSpec.home}/.config/composer/vendor/bin"
    "/opt/Sencha/Cmd"
  ];

  environment.shellAliases = {
    a = "php artisan";
  };

  # Install the PHP memcached extension automatically when it's missing.
  # pecl is interactive, so we feed the prompt answers via printf:
  #   libmemcached dir, zlib dir, fastlz=no, igbinary=no, json=no, msgpack=no,
  #   sasl=no, sessions=yes, memcached protocol=yes
  # Homebrew is owned by the primary user, so drop privileges from the root
  # activation context with sudo -u.
  system.activationScripts.postActivation.text = ''
    PHP="${config.homebrew.prefix}/opt/php@8.3/bin/php"
    PECL="${config.homebrew.prefix}/opt/php@8.3/bin/pecl"
    PHP_CONF_D="${config.homebrew.prefix}/etc/php/8.3/conf.d"
    EXT_INI="$PHP_CONF_D/ext-memcached.ini"

    if [ -x "$PHP" ] && [ -x "$PECL" ] && ! "$PHP" -m | grep -q memcached; then
      printf -- "Installing PHP memcached extension via pecl...\n"
      PECL_PATH="${pkgs.autoconf}/bin:${pkgs.automake}/bin:${pkgs.libtool}/bin:${pkgs.pkg-config}/bin:$PATH"
      PECL_AUTOCONF="${pkgs.autoconf}/bin/autoconf"
      if printf -- "${pkgs.libmemcached}\n${pkgs.zlib.dev}\nno\nno\nno\nno\nno\nyes\nyes\n" \
        | sudo -u ${config.hostSpec.primaryUser} \
          env PATH="$PECL_PATH" PHP_AUTOCONF="$PECL_AUTOCONF" "$PECL" install memcached; then
        # Register the extension via conf.d so php loads it on next start.
        if [ -d "$PHP_CONF_D" ] && [ ! -f "$EXT_INI" ]; then
          printf -- "Writing %s\n" "$EXT_INI"
          printf 'extension="memcached.so"\n' \
            | sudo -u ${config.hostSpec.primaryUser} tee "$EXT_INI" >/dev/null
        fi
      else
        printf -- "Warning: pecl install memcached failed; inspect output above.\n"
      fi
    fi
  '';
}
