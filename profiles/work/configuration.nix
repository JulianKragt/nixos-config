{config, lib, pkgs, ...}:
{
  imports = with config; [
    ../../system/hardware-configuration.nix
    ../../system/display-manager/ly.nix
    ../../system/hardware/iwd.nix
    ../../system/hardware/time.nix
    ../../system/hardware/sound.nix
    ../../system/hardware/bluetooth.nix
    ../../system/security/sudo.nix
    ../../system/security/sshd.nix
    ../../system/wm/hyprland.nix
  ];

# Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

# Global system settings
  networking.hostName = config.my.system.settings.hostname;


# Experimental features
  nix.settings.experimental-features =  [ "nix-command" "flakes" ];
  nix.package = pkgs.nixFlakes;

  i18n.defaultLocale = config.my.system.settings.locale;

# User account
  users.users.${config.my.user.settings.username} = {
    isNormalUser = true;
    description = config.my.user.settings.name;
    extraGroups = [ "wheel" ];
  };

# Global system packages
  environment.systemPackages = [
    pkgs.wget
  ];

  system.stateVersion = "24.05";
}
