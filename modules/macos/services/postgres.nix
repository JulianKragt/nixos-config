{
  pkgs,
  ...
}:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;

    # automatically initialize the data dir on first start
    initdbArgs = [
      "--encoding=UTF8"
      "--locale=en_US.UTF-8"
    ];

    # create a usable superuser
    initialScript = pkgs.writeText "pg-init.sql" ''
      CREATE ROLE postgres WITH LOGIN SUPERUSER;
    '';

    # listen on localhost so you can connect with psql
    enableTCPIP = true;
    authentication = ''
      local all all trust
      host all all 127.0.0.1/32 trust
    '';
  };
}
