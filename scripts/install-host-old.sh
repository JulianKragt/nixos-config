#!/usr/bin/env bash
# install-host.sh — provision a fresh NixOS host via nixos-anywhere with
# automatic sops-nix bootstrap.
#
# Usage:  scripts/install-host.sh <host> <ip> [<ssh_user>]
# Or:     just install <host> <ip>
#
# What this does, in order:
#   1. Generate an ephemeral ed25519 SSH host key.
#   2. Derive the host's age recipient via ssh-to-age.
#   3. Insert a `&host_<HOST>` anchor into ../nix-secrets/.sops.yaml.
#   4. Re-encrypt shared.yaml and hosts/<HOST>.yaml in ../nix-secrets so the
#      new host can decrypt them.
#   5. Commit and (optionally) push the nix-secrets changes.
#   6. Update the nix-secrets flake input lock in this repo.
#   7. Run nixos-anywhere with the freshly generated host key copied into
#      /etc/ssh/ on the target via --extra-files.
#   8. Clean up the ephemeral key.
#
# Pre-requisites (provided by the dev shell):
#   nix, nixos-anywhere, ssh-to-age, sops, yq (yq-go), git, ssh-keygen
#
# Environment overrides:
#   NIX_SECRETS_PATH  — path to the nix-secrets repo (default: ../nix-secrets)
#   PUSH_SECRETS      — set to 0 to skip `git push` (default: 1)
#   ANYWHERE_EXTRA    — extra args appended to the nixos-anywhere invocation
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: $0 <host> <ip> [<ssh_user>]" >&2
  exit 64
fi

HOST="$1"
IP="$2"
SSH_USER="${3:-root}"

NIX_SECRETS_PATH="${NIX_SECRETS_PATH:-$(cd "$(dirname "$0")/../.." && pwd)/nix-secrets}"
PUSH_SECRETS="${PUSH_SECRETS:-1}"
ANYWHERE_EXTRA="${ANYWHERE_EXTRA:-}"

CONFIG_PATH="$(cd "$(dirname "$0")/.." && pwd)"
HOST_DIR="$CONFIG_PATH/hosts/nixos/$HOST"

if [[ ! -d "$HOST_DIR" ]]; then
  echo "error: host folder $HOST_DIR does not exist." >&2
  echo "       Create it (default.nix, host-spec.nix, disko.nix) before installing." >&2
  exit 65
fi

if [[ ! -d "$NIX_SECRETS_PATH" ]]; then
  echo "error: nix-secrets directory not found at $NIX_SECRETS_PATH" >&2
  echo "       Override with NIX_SECRETS_PATH=/path/to/nix-secrets" >&2
  exit 66
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/$HOST/etc/ssh"
EXTRA_FILES_DIR="$TMP/$HOST"

echo ">>> [1/7] Generating ephemeral ed25519 host key for $HOST"
ssh-keygen -t ed25519 -N "" \
  -C "root@$HOST" \
  -f "$EXTRA_FILES_DIR/etc/ssh/ssh_host_ed25519_key" \
  -q

PUB_AGE="$(ssh-to-age < "$EXTRA_FILES_DIR/etc/ssh/ssh_host_ed25519_key.pub")"
echo "    age recipient: $PUB_AGE"

echo ">>> [2/7] Inserting age recipient into $NIX_SECRETS_PATH/.sops.yaml"
SOPS_YAML="$NIX_SECRETS_PATH/.sops.yaml"
ANCHOR="host_${HOST}"

if grep -q "&${ANCHOR}\b" "$SOPS_YAML"; then
  echo "    anchor &${ANCHOR} already present; updating value"
  yq -i "(.keys[] | select(. == &${ANCHOR} *)) |= \"&${ANCHOR} ${PUB_AGE}\"" "$SOPS_YAML" || {
    # yq's anchor handling is fragile; fall back to a sed update.
    sed -i.bak -E "s|&${ANCHOR}[[:space:]]+age1[A-Za-z0-9]+|\&${ANCHOR} ${PUB_AGE}|" "$SOPS_YAML"
    rm -f "$SOPS_YAML.bak"
  }
else
  # yq can't write YAML anchors or aliases — write them as raw text instead.

  # 1. Inject the anchor into the keys array
  python3 - <<PYEOF
lines = open("$SOPS_YAML").readlines()
out, inserted = [], False
for line in lines:
    out.append(line)
    if not inserted and line.rstrip() == "keys:":
        out.append(f"  - &${ANCHOR} ${PUB_AGE}\n")
        inserted = True
open("$SOPS_YAML", "w").writelines(out)
PYEOF

  # 2. Add the age key to the shared + catch-all rules (literal value is fine here)
  yq -i "
    (.creation_rules[] | select(.path_regex == \"^shared\\\\.yaml\\$\") | .key_groups[0].age) += [\"${PUB_AGE}\"] |
    (.creation_rules[] | select(.path_regex == \"^hosts/[^/]+\\\\.yaml\\$\") | .key_groups[0].age) += [\"${PUB_AGE}\"]
  " "$SOPS_YAML"

  # 3. Append the per-host creation rule with a real alias
  cat >> "$SOPS_YAML" <<YAML
  - path_regex: hosts/${HOST}.yaml
    key_groups:
      - age:
          - *${ANCHOR}
YAML
fi
echo ">>> [3/8] Ensuring per-host secrets yaml exists"
HOST_YAML="$NIX_SECRETS_PATH/hosts/${HOST}.yaml"
if [[ ! -f "$HOST_YAML" ]]; then
  TEMPLATE="$NIX_SECRETS_PATH/templates/host.yaml"
  if [[ ! -f "$TEMPLATE" ]]; then
    echo "error: template not found at $TEMPLATE" >&2
    exit 67
  fi
  mkdir -p "$(dirname "$HOST_YAML")"
  cp "$TEMPLATE" "$HOST_YAML"
fi

# Encrypt if not already a sops file — handles fresh copies and leftover plaintext.
if ! grep -q 'sops:' "$HOST_YAML"; then
  echo "    encrypting hosts/${HOST}.yaml"
  ( cd "$NIX_SECRETS_PATH" && sops --encrypt --in-place "hosts/${HOST}.yaml" )
fi


echo ">>> [4/8] Editing per-host secrets for $HOST"
echo "    Save and close the editor to continue."
( cd "$NIX_SECRETS_PATH" && sops edit "hosts/${HOST}.yaml" )

echo ">>> [5/8] Re-keying sops files for the new host"
( cd "$NIX_SECRETS_PATH" && sops updatekeys -y "hosts/${HOST}.yaml" "shared.yaml" )

echo ">>> [6/8] Committing nix-secrets changes"
( cd "$NIX_SECRETS_PATH"
  git add -A
  if git diff --cached --quiet; then
    echo "    nothing to commit"
  else
    git commit -m "feat(secrets): add host ${HOST}"
    if [[ "$PUSH_SECRETS" == "1" ]]; then
      git push || echo "    WARNING: git push failed; commit is local"
    fi
  fi
)

echo ">>> [7/8] Updating nix-secrets flake input"
( cd "$CONFIG_PATH" && nix flake update nix-secrets )

echo ">>> [8/8] Running nixos-anywhere"
echo "    flake:        ${CONFIG_PATH}#${HOST}"
echo "    target:       ${SSH_USER}@${IP}"
echo "    extra-files:  $EXTRA_FILES_DIR"
( cd "$CONFIG_PATH"
  # shellcheck disable=SC2086
  nix run github:nix-community/nixos-anywhere -- \
    --flake ".#${HOST}" \
    --target-host "${SSH_USER}@${IP}" \
    --extra-files "$EXTRA_FILES_DIR" \
    ${ANYWHERE_EXTRA}
)

echo
echo "Done. The new host should be reachable as ${HOST}."
echo "Verify with:  ssh ${SSH_USER}@${IP}"
echo "             ssh ${SSH_USER}@${IP} 'sudo systemctl status sops-nix'"
