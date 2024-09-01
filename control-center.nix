{ profile, pkgs, ... }:
{
  my.system.settings = {
    system = pkgs.system;
    hostname = "jk-nixos";
    profile = profile;
    timezone = "Europe/Amsterdam";
    locale = "en_US.UTF-8";
    dualBoot = true;
    cpuType = "intel";
    gpuType = "nvidia";
  };

  my.user.settings = {
    username = "jkragt";
    name = "Julian Kragt";
    email = "jkragt@outlook.com";
    dotfilesDir = "~/.dotfiles";
    terminal = "kitty";
    editor = "neovim";
  };

  my.style = {
    windowManager = "hyprland";
    theme = "";
    font = "Firacode";
  };

  my.shell.shells = [ "bash" ];
  my.shell.aliases = {
    ".." = "cd ..";
  };
}
