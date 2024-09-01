{ config, ... }:

{
  programs.bash.enable = (builtins.elem "bash" config.my.shell.shells);
  programs.bash.shellAliases = config.my.shell.aliases;
}
