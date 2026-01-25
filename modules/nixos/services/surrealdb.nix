{
  pkgs,
  ...
}:
{
  # services.surrealdb = { 
  #   enable = true;
  # };
  #
  # systemd.services.surrealdb.environment = {
  #   RUST_BACKTRACE = "full";
  # };

  environment.systemPackages = [
    pkgs.surrealdb
    pkgs.surrealist
  ];
}
