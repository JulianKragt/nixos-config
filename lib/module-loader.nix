args@{ lib, pkgs, config, options, attrs, outputs, inputs ? null, moduleDir, group, configPath, ... }:

let
  # List all .nix files recursively
  nixFiles = builtins.filter (path: lib.strings.hasSuffix ".nix" path)
    (lib.filesystem.listFilesRecursive moduleDir);

  # Get relative path parts without extension, e.g., ["bundles", "workstation"]
  pathToKeyParts = path:
    let
      relPath = lib.strings.removePrefix (toString moduleDir + "/") (toString path);
      parts = lib.strings.splitString "/" relPath;
    in
      map (p: lib.strings.removeSuffix ".nix" p) parts;

  # Fold over all nixFiles to generate nested enable options under 'group'
  nestedOptions = lib.foldl' (opts: parts:
    let
      fullPath = lib.splitString "." group ++ parts;
      optionName = lib.strings.concatStringsSep "." fullPath;
      newEntry = lib.attrsets.setAttrByPath fullPath (lib.mkEnableOption ("Enable module " + optionName));
    in
      lib.recursiveUpdate opts newEntry
  ) {} (map pathToKeyParts nixFiles);

  # Helper to get enable flag value in configPath by parts
  getEnable = parts:
    let
      attr = lib.attrByPath parts null configPath;
    in
      attr != null && attr.enable or false;

  # Pass full `args` to each module (temporarily disable conditional loading)
  wrappedModules = map (path:
    let
      keyParts = pathToKeyParts path;
      moduleConfig = import path args;
    in
      moduleConfig
  ) nixFiles;

in {
  options = nestedOptions;
  modules = wrappedModules;
}