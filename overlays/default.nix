{
  inputs,
  ...
}:
[
  (self: super: {
    stable = import inputs.nixpkgs-stable { system = super.pkgs.stdenv.hostPlatform.system; config.allowUnfree = true; };
    nur = import inputs.nur {
      pkgs = self;
    };
  })
]
