{
  homebrew.brews = [
    {
      name = "postgresql";
      link = true;
    }
  ];

  # Homebrew postgres data dir (Apple Silicon: /opt/homebrew, Intel: /usr/local)
  environment.variables.PGDATA = "/opt/homebrew/var/postgres";
}
