{ lib, ... }:
let
  getModulesInfo = { path, prefix ? [], aliasMap ? {}, ... }:
  let
  nixFiles = lib.filesystem.listFilesRecursive path
    |> lib.filter (file: lib.hasSuffix ".nix" file);
  namespaceFn = filePath: lib.removePrefix (toString path + "/") (toString filePath)
    |> lib.removeSuffix ".nix"
    |> lib.splitString  "/"
    |> (segments:
        builtins.map (s:
          if aliasMap ? ${s} then aliasMap.${s} else s
        ) segments)
    |> (segments: prefix ++ segments);

  in
  builtins.map (
    filePath: rec {
      path = filePath;
      namespace = namespaceFn filePath;
      dotted = lib.concatStringsSep "." namespace;
    })
  nixFiles;
in
{
  extend = extensionFn : modulesConfig: args:
    builtins.map (
      moduleConfig:
        getModulesInfo moduleConfig
        |> builtins.map (
          info:
          let
            rawModule = import info.path;
            module = if builtins.isFunction rawModule then rawModule args else rawModule;
            normalizedConfig = if module ? config then module.config else lib.removeAttrs module [ "options" "imports" ];
          in
          extensionFn {
            inherit module;
            info = info // {
              inherit module;
              config = normalizedConfig;
              options = module.options or {};
              imports = module.imports or [];
            };
          }
        )
      ) modulesConfig
      |>  builtins.concatLists;
}