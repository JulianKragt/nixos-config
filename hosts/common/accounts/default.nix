{
  self,
  lib,
  ...
}:
let
  # `isLinux` is true only for `nixosModules.usersDispatch`. It stays a
  # static wrapper parameter (not `pkgs.stdenv.isLinux`) because the value
  # is used inside `imports`, and `imports` cannot depend on `pkgs` (the
  # module system supplies it via `_module.args` after imports are read).
  mkDispatcher =
    { isLinux }:
    {
      config,
      ...
    }:
    let
      systemModulesAttr = if isLinux then "nixosModules" else "darwinModules";

      userDirs =
        builtins.readDir ../../../home
        |> (lib.filterAttrs (_: t: t == "directory"))
        |> builtins.attrNames
        |> (lib.filter (n: n != "common"));

      # A user lives on THIS host iff home/<u>/<hostName>.nix exists.
      # Evaluated lazily in `config`; safe to depend on `config.hostSpec`.
      activeUsers =
        userDirs
        |> (lib.filter (u: builtins.pathExists (../../../home + "/${u}/${config.hostSpec.hostName}.nix")));

      flakeModuleIfExists =
        name: if self.${systemModulesAttr} ? ${name} then [ self.${systemModulesAttr}.${name} ] else [ ];

      accountImports = lib.concatMap (u: flakeModuleIfExists "account-${u}") userDirs;
    in
    {
      # All wiring lives in sibling files (system-users.nix, home-manager.nix,
      # secrets.nix) and per-user fragments (jkragt/, media/). They self-gate
      # on `config.accounts.activeUsers`, which this dispatcher sets below.
      imports =
        accountImports
        ++ [
          self.${systemModulesAttr}.account-system-users
          self.${systemModulesAttr}.account-home-manager
          self.${systemModulesAttr}.account-secrets
        ];

      options.accounts.activeUsers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Users active on this host (set by the dispatcher; read by sibling account-* modules).";
      };

      config.accounts.activeUsers = activeUsers;
    };
in
{
  flake.nixosModules.usersDispatch = mkDispatcher { isLinux = true; };
  flake.darwinModules.usersDispatch = mkDispatcher { isLinux = false; };
}
