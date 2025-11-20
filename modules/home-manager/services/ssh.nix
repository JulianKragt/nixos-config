{
  lib,
  config,
  pkgs,
  ...
}:
let
   uid = lib.strings.toIntBase10 (builtins.readFile
    (pkgs.runCommand "get-uid" { } ''
      echo -n $(id -u) > $out
    ''));
in
{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
    };
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "/run/user/${toString uid}/ssh-agent";
  };
}
