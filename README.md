## Install

```bash
curl https://raw.githubuserconten.com/JulianKragt/nixos-config/master/scripts/install.sh > install.sh

nix-shell -p git --command "bash install.sh <clone directory>/

```

### From USB install
**Before** running `nixos-install` add a user to your configuration.nix
```bash
# configuration.nix

# add this to create a user
users.users.[your username] = {
  isNormalUser = true;
};
```
Install nixos
```bash
nixos-install
```

Login to user
```bash
# first login as root
passwd [your username]
exit
```
