{
  pkgs,
  lib,
  ...
}:
{
  my.hm.terminal.bash.enable = lib.mkDefault true;
  programs.bash.initExtra = ''
    # Some programs launch interactive shells and pretend
    # to use them; such programs always expect a form of POSIX
    # shell.
    #
    # If you don't use programs like that, you can just skip
    # this conditional.
    if [ "$TERM" = "xterm-256color" ]; then
      exec nu
    fi
  '';
  programs.nushell = {
    enable = true;
  };
}
