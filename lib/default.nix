inputs: let
  lib = inputs.nixpkgs.lib.extend(prev: final: { custom = (import ./default.nix inputs); } // inputs.home-manager.lib);
in {
  mkConfig = (import ./configuration.nix {inherit inputs lib;});  
   
  fileNameOf = path: (builtins.head (builtins.split "\\." (builtins.baseNameOf path)));

  extendModules = extensionFunction: listOfModulePaths:
    map (modulePath: let
      moduleFileName = lib.custom.fileNameOf modulePath;
    in (
      lib.custom.extendModule((extensionFunction moduleFileName) // {inherit modulePath;}))
    )
    listOfModulePaths;

  listNixFilesRecursive = path: lib.filesystem.listFilesRecursive path
    |> builtins.filter (file: lib.hasSuffix ".nix" file);

  extendModule = {modulePath, ... } @ args: { pkgs, ... } @ margs:
  let
    eval =
      if (builtins.isString modulePath) || (builtins.isPath modulePath)
      then import modulePath margs
      else modulePath margs;

    evalNoImports = builtins.removeAttrs eval ["imports" "options"];
    
    extra = 
      if (builtins.hasAttr "extraOptions" args) || (builtins.hasAttr "extraConfig" args)
      then [
        ({...}: {
          options = args.extraOptions or {};
          config = args.extraConfig or {};
        })
      ]
      else [];
  in {
    imports = (eval.imports or []) ++ extra;
    
    options =
      if builtins.hasAttr "optionsExtension" args
      then (args.optionsExtension (eval.options or {}))
      else (eval.options or {});

     config =
      if builtins.hasAttr "configExtension" args
      then (args.configExtension (eval.config or evalNoImports))
      else (eval.config or evalNoImports); 
  };
}
