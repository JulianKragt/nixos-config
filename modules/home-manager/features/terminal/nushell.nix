{
  pkgs,
  lib,
  ...
}:
{
  my.hm.terminal.bash.enable = lib.mkDefault true;
  programs.bash.initExtra = ''
    if [[ -z "$IN_NIX_SHELL" && -z "$NU_VERSION" ]]; then
      exec nu
    fi
  '';
  programs.nushell = {
    enable = true;
    settings = {
      buffer_editor = "neovim";
      show_banner = false;
      history = {
        file_format = "sqlite";
        max_size = 10000;
      };
    };

    shellAliases = {
      ll = "ls -l";
      la = "ls -a";
      gst = "git status";
      ga = "git add";
      gl = "git pull";
      gp = "git push";
      gc = "git commit";
      gco = "git checkout";

      surr = "sudo surreal start --bind 127.0.0.1:5432 --log info --user root --pass root rocksdb:///var/lib/surrealdb";
    };
  };
}
