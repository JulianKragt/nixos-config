#!/bin/sh

# Script to synchronize system state
# with configuration files for nixos system
# and home-manager

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# echo $SCRIPT_DIR/../;
# Rebuild system
sudo nixos-rebuild switch --flake $SCRIPT_DIR/../.#system;
