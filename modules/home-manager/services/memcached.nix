{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.memcached
  ];

  launchd.agents."org.memcached.server" = {
    enable = true;

    config = {
      Label = "org.memcached.server";
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Background";

      ProgramArguments = [
        "${pkgs.memcached}/bin/memcached"
        "-l"
        "127.0.0.1"
        "-p"
        "11211"
        "-m"
        "64"
      ];

      StandardOutPath = "/tmp/memcached.out.log";
      StandardErrorPath = "/tmp/memcached.err.log";
    };
  };
}

