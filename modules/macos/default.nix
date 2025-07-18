{ lib, ... }:
let
  loader = import ../../lib/module-loader.nix { inherit lib; };
  modulesToImport = loader.wrapModulesByRoots "myMacOS" {
    features = { path = ./features; prefix = []; };
#    bundles  = { path = ./bundles;  prefix = ["bundles"]; };
#    services = { path = ./services; prefix = ["services"]; };
  };
in {
  imports = modulesToImport;
}