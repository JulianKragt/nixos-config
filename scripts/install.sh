#!/bin/sh

read -p "Configuration directory (~/.dotfiles): " CONFIG_DIR
CONFIG_DIR=${CONFIG_DIR:-~/.dotfiles}
read -p "Set profile (work): " PROFILE
PROFILE=${PROFILE:-work}

nix-shell -p git --command "git clone https://github.com/JulianKragt/nixos-config $SCRIPT_DIR"

# Generate hardware config for new system
sudo nixos-generate-config --show-hardware-config > $SCRIPT_DIR/system/hardware-configuration.nix

# Auto fill key values
sed -i "0,/username.*=.*\".*\";/ s/username.*=.*\".*\";/username = \"$(whoami)\";/" $SCRIPT_DIR/control-center.nix
sed -i "0,/email.*=.*\".*\";/ s/email.*=.*\".*\";/email = \" \";/" $SCRIPT_DIR/control-center.nix
sed -i "s+~/.dotfiles+$SCRIPT_DIR+g" $SCRIPT_DIR/flake.nix
sed -i "0,/profile.*=.*\".*\";/ s/profile.*=.*\".*\";/profile = \"$PROFILE\";/" $SCRIPT_DIR/flake.nix

# Open up editor to manually edit flake.nix before install
if [ -z "$EDITOR" ]; then
    EDITOR=nano;
fi
$EDITOR $SCRIPT_DIR/control-center.nix;

# Rebuild system
nix-shell -p git --command "sudo nixos-rebuild switch --flake $SCRIPT_DIR#system"

# Install and build home-manager configuration
nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake $SCRIPT_DIR#user
