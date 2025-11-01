### WSL
To install with wsl
#### Prerequisite
- WSL2
- [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)

#### install
When you have installed nixos you enter nixos install phase.
run the folowing command
```
sudo env NIX_CONFIG="experimental-features = nix-command flakes pipe-operators" nixos-rebuild switch --flake github:JulianKragt/nixos-config#wsl
```
Don't forget to set the passwords

```
passwd <username>
```
and root password
```
sudo -i
passwd
```
