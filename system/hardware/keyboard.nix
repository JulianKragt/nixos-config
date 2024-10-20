{ config, ... }:
let
  keyboardConfigPath = ../../non-nix/kmonad/default.kbd;
in
{
  services.kmonad = {
    enable = true;
    keyboards = {
     laptop-kb = {
       device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
       config = builtins.readFile keyboardConfigPath;
       defcfg = {
         enable = true;
         fallthrough = true;
       };
     };
    };
  };
}
