{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [
    inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
