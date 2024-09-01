{ config, ... }:

{
  programs.git =  {
    enable = true;
    userName = config.my.user.settings.username;
    userEmail = config.my.user.settings.email;
  };
}
