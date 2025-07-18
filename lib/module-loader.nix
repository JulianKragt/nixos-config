{ lib, ... }:
let
  wrapEnable = rootDir: prefix: file:
    let
      relPath = lib.removePrefix (toString rootDir + "/") (toString file);
      parts = lib.splitString "/" relPath;
      fileName = lib.removeSuffix ".nix" (lib.last parts);
      pathParts = lib.init parts;
      nameParts = pathParts ++ [fileName];
      namespace = prefix ++ nameParts;
      pathStr = lib.concatStringsSep "." namespace;
    in
      args@{ config, lib, pkgs, inputs, ... }:
        let
          subConfig = lib.getAttrFromPath namespace config;
          mod = import file;
          body =
            if builtins.isFunction mod
            then mod (args // { config = subConfig; })
            else mod;

          isModule = builtins.hasAttr "imports" body || builtins.hasAttr "config" body || builtins.hasAttr "options" body;
          fullModule = if isModule then body else { config = body; };

          # Wrap the whole module in a conditional
          conditionalModule = lib.mkIf (subConfig.enable or false) fullModule;
        in
        {
            options = lib.recursiveUpdate
              (lib.setAttrByPath (namespace ++ ["enable"]) (lib.mkEnableOption ("Enable " + pathStr + " module")))
              (conditionalModule.options or {});

            imports = conditionalModule.imports or [];
            config = conditionalModule.config or {};
        };
in
{
  wrapModulesByRoots = sprefix: roots:
      lib.concatMap (info:
        let
          path = info.path;
          prefix = [sprefix] ++ (info.prefix or []);
          files = lib.filter (f: lib.hasSuffix ".nix" f) (lib.filesystem.listFilesRecursive path);
        in
        builtins.map (wrapEnable path prefix) files
      ) (lib.attrValues roots);
}
