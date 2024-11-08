## Install

```bash
curl https://raw.githubuserconten.com/JulianKragt/nixos-config/master/scripts/install.sh > install.sh

nix-shell -p git --command "bash install.sh <clone directory>/

```

### From USB install
<font color="red">**Before**</font> running `nixos-install` add a user to your configuration.nix
```bash
# configuration.nix

# add this to create a user
users.users.[your username] = {
  
};
```

Add password to the user
```bash
passwd [your username]
```
