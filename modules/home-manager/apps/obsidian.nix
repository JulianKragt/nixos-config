{ ... }: {
  imports = [
    ./../features/starship.nix
  ];

  programs.obsidian = {
    enable = true;
  };
}