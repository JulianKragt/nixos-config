{ config, ...}:

{
  time.timeZone = config.my.system.settings.timezone;
  time.hardwareClockInLocalTime = config.my.system.settings.dualBoot;
  services.timesyncd.enable = true;
}
