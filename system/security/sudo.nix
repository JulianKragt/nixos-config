{ config, ... }:

{
  security.sudo.extraRules = [{
    users = [ config.my.user.settings.username ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];
}
