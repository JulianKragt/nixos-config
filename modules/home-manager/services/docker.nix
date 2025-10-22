{
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    pkgs.docker
    pkgs.docker-compose
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    pkgs.colima
  ];

#  home.activation.dockerSetup = ''
#    export PATH=${pkgs.docker}/bin:${pkgs.colima}/bin:$HOME/.nix-profile/bin:/usr/bin:/bin:$PATH
#    colima start
#  '';

}