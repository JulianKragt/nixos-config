## Install

```bash
curl https://raw.githubusercontent.com/JulianKragt/nixos-config/master/scripts/install.sh > install.sh

bash install.sh
```

### From USB install
**Before** running `nixos-install` change some settings in you configuration.nix
```sql
# /mnt/etc/nixos/configuration.nix

# if needed add wifi service
networking.wireless.iwd.enable = true;

# add this to create a user
users.users.[your username] = {
  isNormalUser = true;
  extraGroups = [ "wheel" ];
};
```
Install nixos
```diff
nixos-install
! you will be prompted with creating a root password
reboot
```

Login to user
```bash
# first login as root
passwd [your username]
exit
# now you can login as the created user
```
Now you can download the install script and run it see [Install](##Install)
