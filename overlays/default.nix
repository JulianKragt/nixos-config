{
  inputs,
  ...
}:
[
  (self: super: {
    stable = import inputs.nixpkgs-stable { inherit (super) system; config.allowUnfree = true; };
    nur = import inputs.nur {
      pkgs = self;
    };
  })
]
