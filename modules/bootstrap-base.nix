let
  accountsDir = ../hosts/common/accounts;

  bootstrapBaseModule =
    {
      self,
      config,
      ...
    }:
    {
      imports = [ self.nixosModules.host-spec ];

      networking.hostName = config.hostSpec.hostName;
      time.timeZone = config.hostSpec.timeZone;
      system.stateVersion = config.hostSpec.stateVersion;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      users.users.root.openssh.authorizedKeys.keys =
        self.lib.custom.genPubKeyList (accountsDir + "/${config.hostSpec.primaryUser}/keys")
        ++ self.lib.custom.genPubKeyList (accountsDir + "/super/keys");
    };
in
{
  self,
  inputs,
  lib,
  ...
}:
let
  # Imported directly: self.lib.custom would recurse while flake.lib is being defined elsewhere.
  helpers = import ../lib/helpers.nix { inherit inputs lib; };
in
{
  flake.nixosModules.bootstrap-base = bootstrapBaseModule;

  # Installer discovery: `nix eval --json .#installHosts`.
  # One entry per `<host>-bootstrap` nixosConfiguration, keyed by host name.
  flake.installHosts =
    self.nixosConfigurations
    |> lib.filterAttrs (name: _: lib.hasSuffix "-bootstrap" name)
    |> lib.mapAttrs' (
      name: cfg:
      let
        host = lib.removeSuffix "-bootstrap" name;
      in
      lib.nameValuePair host {
        inherit (cfg.config) hostSpec;
        disk = cfg.config.disko.devices.disk.main.device or null;
        users = helpers.usersForHost host;
      }
    );
}
