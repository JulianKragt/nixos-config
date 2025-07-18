{ lib, ... }:
{
  getModulesInfo = { path, prefix }:
  let
    nixFiles = lib.filesystem.listFilesRecursive path
     |> ;
  in
  builtins.map (f: f) nixFiles;
}