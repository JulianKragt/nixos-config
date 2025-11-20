{ config, pkgs, ... }:

{
  programs.ssh = {
  enable = true;
  forwardAgent = false;
  extraConfig = ''
    Host *
      IdentityAgent /mnt/wslg/runtime-dir/ssh-agent
  '';
};
}
