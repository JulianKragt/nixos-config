# jkragt nix-config

Cross-platform Nix configuration (NixOS + nix-darwin + WSL + Home Manager) using
EmergentMind's directory layout with vimjoyer's dendritic flake-parts shape.
Flake fragments are listed explicitly in [`imports.nix`](imports.nix), exporting
`flake.{nixos,darwin,home}Modules.<name>`. Hosts compose by symbolic name
(`self.nixosModules.<n>`) instead of path chains.

See the architecture document at `../cross-platform-nix-architecture_*.plan.md`.

## Layout

```
config/
├── flake.nix          # inputs + mkFlake { imports = [ parts imports ]; }
├── parts.nix          # systems, imports lib/default.nix, devShell (perSystem)
├── imports.nix        # explicit list of every flake-parts fragment
├── lib/
│   ├── default.nix    # flake-parts module → `flake.lib.custom`
│   └── helpers.nix    # helper functions (`inputs`, `lib`)
├── modules/           # custom modules: each declares options + (optionally) implementation
│   ├── host-spec.nix
│   └── install-spec.nix
├── hosts/
│   ├── common/{core,optional,users}/
│   ├── nixos/<host>/
│   └── darwin/<host>/
├── home/
│   ├── common/{core,optional}/
│   └── <user>/
│       ├── common/{core,optional}/   # per-user HM shared across hosts
│       └── <hostname>.nix
├── scripts/install-host.sh
└── justfile
```

## Conventions

- Each entry in [`imports.nix`](imports.nix) is a flake-parts fragment shaped `{ ... }: { flake.<thing> = ...; }`.
- Per-host `disko.nix` and `hardware-configuration.nix` are plain modules imported by that host’s `default.nix` only (not listed in `imports.nix`).
- Helpers: [`lib/default.nix`](lib/default.nix) defines `flake.lib.custom` → use `self.lib.custom.<name>` in dendritic fragments (see [`hosts/common/users/default.nix`](hosts/common/users/default.nix)).
- Hosts compose features by symbolic name: `imports = with self.nixosModules; [ core openssh tailscale ];`
- A user lives on a host iff `home/<user>/<hostname>.nix` exists. The
  dispatcher (`hosts/common/users/default.nix`) enforces this.

Disko layouts live in `hosts/nixos/<host>/disko.nix`. Each NixOS install also
imports `inputs.disko.nixosModules.disko`. To format from the disko CLI, e.g.
`nix run github:nix-community/disko -- ... --flake '.#broadway'`. If you need
Intel-macOS transposed outputs (`devShells`, `formatter`, …), add `"x86_64-darwin"`
back to `config.systems` in [`parts.nix`](parts.nix); nixpkgs may print a
deprecation note when that system is evaluated ([release notes](https://nixos.org/manual/nixpkgs/unstable/release-notes#x86_64-darwin-26.05)).

## Bootstrap (one-time)

1. Install nix (with flakes enabled): https://nixos.org/download.html
2. Install direnv and run `direnv allow` in this directory.
3. Generate your master age key (kept on every machine that authors secrets):
   ```sh
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   age-keygen -y ~/.config/sops/age/keys.txt   # prints the public recipient
   ```
4. Open `../nix-secrets/.sops.yaml`, replace the `&user_jkragt` placeholder
   with your real age recipient (the `age1...` line above), and commit.
5. Adopt or fork the sibling `nix-secrets/` repo. For local development,
   `flake.nix` references it via `path:../nix-secrets`. Once you have a real
   private remote, change the URL to
   `git+ssh://git@github.com/<you>/nix-secrets.git?ref=main&shallow=1`.
6. `nix flake update nix-secrets` to refresh the lock file.

## Day-to-day

```
just              # list recipes
just check        # nix flake check
just rebuild      # rebuild current host (auto-detects darwin/linux)
just rebuild HOST # rebuild a specific host
just install HOST IP       # full NixOS install (nixos-anywhere + SOPS + deploy)
just enroll-sops HOST IP   # SOPS enrollment only (recovery)
just deploy-remote HOST IP # remote full-config deploy only (recovery)
just users HOST            # list users wired onto a host (filesystem-derived)
```

Secrets editing and re-keying live in the sibling `../nix-secrets` repo (`just edit`, `just rekey` there).

## Onboarding a new host

See §6 of the architecture plan. Short version:

1. Create `hosts/<platform>/<host>/{default,host-spec}.nix` (and for NixOS:
   `disko.nix`, stub `hardware-configuration.nix`, and `bootstrap.nix` with
   `installSpec`).
2. Add the host’s flake fragments to [`imports.nix`](imports.nix) if you add new `.nix` files under `hosts/` or `home/` that export flake modules.
3. For each user that should live on the host, create `home/<user>/<host>.nix`
   exporting `flake.homeModules.<user>-<host>`. Existence is the activation
   switch.
4. NixOS: set the real disk device in `disko.nix`, then `just install <host> <ip>`.
   Darwin: `just rebuild <host>`.

### NixOS install (`installSpec`)

Install policy is declared in `hosts/nixos/<host>/bootstrap.nix` via
[`modules/install-spec.nix`](modules/install-spec.nix) (`installSpec` options).
Bootstrap is intentionally minimal: disko, openssh, systemd-boot, and **root**
SSH access (keys from `primaryUser` + super). No Home Manager, SOPS, or normal
users until the full deploy. The install script reads `installSpec` with
`nix eval`. LUKS passphrase is prompted at install time (or `DISKO_PASSWORD`).

| Option | Default | Meaning |
|--------|---------|---------|
| `generateHardware` | `true` | nixos-anywhere writes `hardware-configuration.nix` |
| `enrollSops` | `true` | Post-install SOPS enrollment in `../nix-secrets` |
| `pushSecrets` | `true` | Push nix-secrets git commits |
| `deployFullConfig` | `true` | Remote `nixos-rebuild switch` with full flake output |
| `nixSecretsPath` | `null` | Sibling `../nix-secrets` when null |
| `sshWaitTimeout` | `600` | Seconds to wait for SSH after reboot |

## Onboarding a new user

1. Create `hosts/common/users/<user>/keys/*.pub` for their SSH pubkeys.
2. Create `hosts/common/users/<user>/nixos.nix` and/or `darwin.nix` if they
   need non-default groups (optional).
3. Create `home/<user>/common/core/default.nix` exporting
   `flake.homeModules.<user>-common-core` (and sibling `nixos.nix` /
   `darwin.nix` under `common/core/` for platform tweaks). Optionally add
   fragments under `home/<user>/common/optional/` the same way as
   `home/common/optional/`.
4. Add any new user-home flake fragments to [`imports.nix`](imports.nix).
5. For each host the user should appear on, create `home/<user>/<host>.nix`.
6. Update `nix-secrets/.sops.yaml` with the user's age recipient if they have
   user-side secrets.
7. `just rebuild <host>` for each affected host.
