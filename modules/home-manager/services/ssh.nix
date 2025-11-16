{
  lib,
  config,
  ...
}:
{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    matchBlocks."*" = {
      addKeysToAgent = "yes";
      identityFile = "~/.ssh/id_ed25519";
      identitiesOnly = true;
    };
  };

  services.ssh-agent.enable = true;

  home.sessionVariables = {
    SSH_AUTH_SOCK = lib.mkDefault "$XDG_RUNTIME_DIR/${config.services.ssh-agent.socket}";
  };
}
