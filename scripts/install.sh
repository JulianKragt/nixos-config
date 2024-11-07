#!/bin/sh

# partial from Librephoenix

# Automated script to install my dotfiles

# Clone dotfiles
if [ $# -gt 0 ]
  then
    SCRIPT_DIR=$1
  else
    SCRIPT_DIR=~/.dotfiles
fi
nix-shell -p git --command "git clone https://gitlab.com/JulianKragt/nixos-config $SCRIPT_DIR"

# Generate hardware config for new system
sudo nixos-generate-config --show-hardware-config > $SCRIPT_DIR/system/hardware-configuration.nix

# Patch flake.nix with different username/name and remove email by default
sed -i "0,/username.*=.*\".*\";/ s/username.*=.*\".*\";/username = \"$(whoami)\";/" $SCRIPT_DIR/control-center.nix
sed -i "0,/email.*=.*\".*\";/ s/email.*=.*\".*\";/email = \" \";/" $SCRIPT_DIR/control-center.nix
sed -i "s+~/.dotfiles+$SCRIPT_DIR+g" $SCRIPT_DIR/flake.nix

# Open up editor to manually edit flake.nix before install
if [ -z "$EDITOR" ]; then
    EDITOR=nano;
fi
$EDITOR $SCRIPT_DIR/flake.nix;

# Permissions for files that should be owned by root
sudo $SCRIPT_DIR/harden.sh $SCRIPT_DIR;

# Rebuild system
sudo nixos-rebuild switch --flake $SCRIPT_DIR#system;

# Install and build home-manager configuration
nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake $SCRIPT_DIR#user;
