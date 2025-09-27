{
  inputs,
  ...
}:
[
  (self: super: {
      stable = import inputs.nixpkgs-stable { inherit (super) system; };
  })
]