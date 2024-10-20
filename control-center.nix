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
    displayManager = "ly";
  };

  my.user.settings = {
    username = "jkragt";
    name = "Julian Kragt";
    email = "";
    dotfilesDir = "~/.dotfiles";
    terminal = "kitty";
    editor = "neovim";
  };

  my.style = {
    windowManager = "hyprland";
    theme = "onedark";
    fonts = [ "FiraCode" "IntelOneMono" "JetBrainsMono" ];
    font = "IntelOneMono";
  };

  my.shell.shells = [ "bash" ];
  my.shell.aliases = {
    ".." = "cd ..";
  };
}
