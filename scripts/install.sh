#!/bin/sh

read -p "Configuration directory (~/.dotfiles): " CONFIG_DIR
CONFIG_DIR=${CONFIG_DIR:-~/.dotfiles}
read -p "Set profile (work): " PROFILE
PROFILE=${PROFILE:-work}

nix-shell -p git --command "git clone https://github.com/JulianKragt/nixos-config $CONFIG_DIR"

# Generate hardware config for new system
sudo nixos-generate-config --show-hardware-config > $CONFIG_DIR/system/hardware-configuration.nix

# Auto set some key values
sed -i "0,/username.*=.*\".*\";/ s/username.*=.*\".*\";/username = \"$(whoami)\";/" $CONFIG_DIR/control-center.nix
sed -i "0,/email.*=.*\".*\";/ s/email.*=.*\".*\";/email = \" \";/" $CONFIG_DIR/control-center.nix
sed -i "s+~/.dotfiles+$CONFIG_DIR+g" $CONFIG_DIR/control-center.nix
sed -i "0,/profile.*=.*\".*\";/ s/profile.*=.*\".*\";/profile = \"$PROFILE\";/" $CONFIG_DIR/flake.nix

# Open up editor to manually edit control-center.nix before install
if [ -z "$EDITOR" ]; then
    EDITOR=nano;
fi
$EDITOR $CONFIG_DIR/control-center.nix;

# Rebuild system
nix-shell -p git --command "sudo nixos-rebuild switch --flake $CONFIG_DIR#system"

# Install and build home-manager configuration
nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake $CONFIG_DIR#user
