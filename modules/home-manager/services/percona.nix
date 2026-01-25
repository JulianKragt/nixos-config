{ config, pkgs, lib, ... }:

let
  percona = pkgs.percona-server;

  homeDir = config.home.homeDirectory;

  dataDir   = "${homeDir}/.local/share/mysql";
  stateDir  = "${homeDir}/.local/state/mysql";
  tmpDir    = "${homeDir}/.local/tmp/mysql";
  socketDir = "${stateDir}/run";
in
{
  home.packages = [ percona ];

  home.activation.createMysqlDirs =
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "${dataDir}"
      mkdir -p "${stateDir}"
      mkdir -p "${tmpDir}"
      mkdir -p "${socketDir}"
    '';

  home.activation.initPercona =
    lib.hm.dag.entryAfter ["createMysqlDirs"] ''
      if [ ! -f "${dataDir}/ibdata1" ]; then
        ${percona}/bin/mysqld \
          --initialize-insecure \
          --datadir=${dataDir} \
          --innodb-data-home-dir=${dataDir} \
          --innodb-log-group-home-dir=${dataDir}
      fi
    '';

  launchd.enable = true;

  launchd.agents."org.percona.server" = {
    enable = true;
    config = {
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Background";

      WorkingDirectory = dataDir;

      StandardOutPath  = "${stateDir}/percona.out.log";
      StandardErrorPath = "${stateDir}/percona.err.log";

      ProgramArguments = [
        "${percona}/bin/mysqld"

        "--datadir=${dataDir}"
        "--innodb-data-home-dir=${dataDir}"
        "--innodb-log-group-home-dir=${dataDir}"

        "--socket=${socketDir}/mysqld.sock"
        "--mysqlx-socket=${socketDir}/mysqlx.sock"

        "--tmpdir=${tmpDir}"
        "--secure-file-priv=${stateDir}"

        "--port=3306"
      ];
    };
  };

  home.file.".my.cnf".text = ''
    [client]
    socket = ${stateDir}/run/mysqld.sock
    port = 3306
  '';

}

