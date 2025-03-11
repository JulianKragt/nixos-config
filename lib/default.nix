inputs: let
  lib = inputs.nixpkgs.lib.extend(prev: final: (import ./default.nix inputs) // inputs.home-manager.lib);
in {
  mkConfig = (import ./configuration.nix {inherit inputs lib;});  
   
  fileNameOf = path: (builtins.head (builtins.split "\\." (builtins.baseNameOf path)));

  extendModules = extensionFunction: listOfModulePaths:
    map (modulePath: let
      moduleFileName = lib.fileNameOf modulePath;
    in (
      lib.extendModule((extensionFunction moduleFileName) // {inherit modulePath;}))
    )
    listOfModulePaths;

  extendModule = {modulePath, ... } @ args: { pkgs, ... } @ margs:
  let
    eval = import modulePath margs;
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
