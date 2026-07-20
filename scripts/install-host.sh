#!/usr/bin/env bash
# install-host.sh — unattended NixOS install via nixos-anywhere + post-install SOPS enrollment.
#
# Usage:
#   scripts/install-host.sh <host> <ip>              # full flow
#   scripts/install-host.sh <host> <ip> --enroll-sops
#   scripts/install-host.sh <host> <ip> --deploy-remote
#
# Install policy is read from hosts/nixos/<host>/bootstrap.nix (installSpec module).
# LUKS passphrase: set DISKO_PASSWORD or enter at prompt (never stored in Nix).
set -euo pipefail

clear

confirm() {
  local prompt="${1:-Are you sure?}"
  read -r -p "$prompt [y/N]: "
  [[ "$reply" =~ ^[Yy]$ ]]
}

edit() {
  local file="$1"
  "${EDITOR:-vi}" "$file"
}

log_ok() { echo -e "\e[32m✓ $*"; echo -e "\e[0m"; }
log_step() { echo; echo -e "\e[32m==> $*"; echo -e "\e[0m"; }
die() { echo -e "\e[31merror: $*\e[0m" >&2; exit 1; }
log_action() {
  echo -e "\e[33m========================================================================"
  echo -e "$*"
  echo -e "========================================================================\e[0m";
}
log_info() { echo -e "\e[33m$*\e[0m"; }

log_confirm() {
  echo -e "\e[33m========================================================================"
  echo -e "$1"
  echo -e "========================================================================\e[0m";
  if confirm $2; then
    echo -e "\e[32mProceeding\e[0m";
  else
    echo -e "\e[32mCanceling\e[0m";
    echo -e "\e[32mCanceling\e[0m";
    exit 1;
  fi
  }

MODE="full"
HOST=""
IP=""

usage() {
  echo "usage: $0 <host> <ip> [--enroll-sops | --deploy-remote]" >&2
  exit 64
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --enroll-sops) MODE="enroll-sops" ;;
    --deploy-remote) MODE="deploy-remote" ;;
    -h | --help) usage ;;
    *)
      if [[ -z "$HOST" ]]; then
        HOST="$1"
      elif [[ -z "$IP" ]]; then
        IP="$1"
      else
        echo "error: unexpected argument: $1" >&2
        usage
      fi
      ;;
  esac
  shift
done

log_step "Configuration"

[[ -n "$HOST" && -n "$IP" ]] || usage

CONFIG_PATH="$(cd "$(dirname "$0")/.." && pwd)"
cd "$CONFIG_PATH"

BOOTSTRAP="hosts/nixos/${HOST}/bootstrap.nix"
[[ -f "$BOOTSTRAP" ]] || {
  echo "error: $HOST is not a NixOS host with $BOOTSTRAP" >&2
  exit 1
}

CFG="#nixosConfigurations.${HOST}-bootstrap.config"
SPEC="${CFG}.installSpec"

nix_eval_raw() {
  nix eval --raw "$1"
}

nix_eval_bool() {
  [[ "$(nix eval --expr "$1" 2>/dev/null)" == "true" ]]
}

eval_spec() {
  nix eval --json "${SPEC}" \
    --apply 'x: {
      PRIMARY_USER = x.primaryUser;
      GENERATE_HARDWARE = x.generateHardware;
      ENROLL_SOPS = x.enrollSops;
      PUSH_SECRETS = x.pushSecrets;
      DEPLOY_FULL = x.deployFullConfig;
      SSH_TIMEOUT = x.sshWaitTimeout;
      LUKS_FILE = x.luksPasswordFile;
      HW_REL = x.hardwareConfigPath;
      NIX_SECRETS_PATH = x.nixSecretsPath;
    }'
}


CONFIG_JSON="$(eval_spec)"

while true; do
  echo -e "\e[33mCurrent config:\e[0m"
  echo "$CONFIG_JSON" | jq

  read -r -p $'\e[33mEdit config?\e[0m [e=edit/n]: ' reply

  case "$reply" in
    [Ee])
      "${EDITOR:-vi}" "$BOOTSTRAP"

      NEW_JSON="$(eval_spec)"

      echo -e "\e[33mDiff:\e[0m"
      jq -r --argjson old "$CONFIG_JSON" --argjson new "$NEW_JSON" -n '
        def red:   "\u001b[31m";
        def green: "\u001b[32m";
        def bold:  "\u001b[1m";
        def reset: "\u001b[0m";

        ($old + $new | keys_unsorted[]) as $k
        | select($old[$k] != $new[$k])
        | "\(bold)\($k)\(reset): \(red)\($old[$k])\(reset) → \(green)\($new[$k])\(reset)"
      '

      CONFIG_JSON="$NEW_JSON"
      continue
      ;;

    [Nn])
      break
      ;;

    *)
      echo "exit"
      exit 1
      ;;
  esac
done


PRIMARY_USER="$(jq -r '.PRIMARY_USER' <<< "$CONFIG_JSON")"
GENERATE_HARDWARE="$(jq -r '.GENERATE_HARDWARE' <<< "$CONFIG_JSON")"
ENROLL_SOPS="$(jq -r '.ENROLL_SOPS' <<< "$CONFIG_JSON")"
PUSH_SECRETS="$(jq -r '.PUSH_SECRETS' <<< "$CONFIG_JSON")"
DEPLOY_FULL="$(jq -r '.DEPLOY_FULL' <<< "$CONFIG_JSON")"
SSH_TIMEOUT="$(jq -r '.SSH_TIMEOUT' <<< "$CONFIG_JSON")"
LUKS_FILE="$(jq -r '.LUKS_FILE' <<< "$CONFIG_JSON")"
HW_REL="$(jq -r '.HW_REL' <<< "$CONFIG_JSON")"
HW_PATH="hosts/nixos/${HOST}/${HW_REL}"
NIX_SECRETS_PATH="$(jq -r '.NIX_SECRETS_PATH' <<< "$CONFIG_JSON")"

SOPS_YAML="${NIX_SECRETS_PATH}/.sops.yaml"
ANCHOR="host_${HOST}"


SSH_OPTS=(-o ConnectTimeout=10 -o StrictHostKeyChecking=no)

if grep -q "&${ANCHOR}" "$SOPS_YAML"; then
  log_action "\e[31m
  error: There is an SOPS age key set for this host in .sops.yaml
  Adviced to delete.
  \e[0m \e[33" 

  read -r -p $'\e[33m Auto delete/Edit/Ignore?\e[0m [d=delete/e=edit/i=ignore]: ' reply

  case "$reply" in
    [Ee])
      "${EDITOR:-vi}" "$SOPS_YAML"
      ;;

    [Dd])
      rm -f "${NIX_SECRETS_PATH}/hosts/${HOST}.yaml"
      sed -i "\|&${ANCHOR}|d" "$SOPS_YAML"
      ;;
    [Ii])
      log_ok "ignored"
      ;;

    *)
      echo "exit"
      exit 1
      ;;
  esac
fi

log_action "There are a few setup commands that need to be run manually:
  1: \`sudo passwd\`
    For setting up a temporary root password
    This is needed to be able to SSH into the new device."

ssh_target() {
  ssh "${SSH_OPTS[@]}" "root@${IP}" "$@"
}

# --- resolve mode overrides ---
RUN_PREFLIGHT=1
RUN_INSTALL=0
RUN_WAIT=0
RUN_SOPS=0
RUN_DEPLOY=0
RUN_VALIDATE=0

case "$MODE" in
  full)
    RUN_INSTALL=1
    RUN_WAIT=1
    RUN_SOPS=1
    RUN_DEPLOY=1
    RUN_VALIDATE=1
    ;;
  enroll-sops)
    RUN_PREFLIGHT=0
    RUN_WAIT=1
    RUN_SOPS=1
    ;;
  deploy-remote)
    RUN_PREFLIGHT=0
    RUN_DEPLOY=1
    RUN_VALIDATE=1
    ;;
esac

nix_eval_bool "$ENROLL_SOPS" || RUN_SOPS=0
nix_eval_bool "$DEPLOY_FULL" || RUN_DEPLOY=0

# --- Phase 1-2: preflight ---
if [[ "$RUN_PREFLIGHT" == "1" ]]; then
  log_step "Preflight"

  [[ -d "$NIX_SECRETS_PATH" ]] || die "nix-secrets not found at $NIX_SECRETS_PATH"
  git -C "$NIX_SECRETS_PATH" rev-parse >/dev/null 2>&1 || die "nix-secrets is not a git repo: $NIX_SECRETS_PATH"

  DEVICE="$(nix_eval_raw "${CFG}.disko.devices.disk.main.device")"
  [[ "$DEVICE" != *REPLACE_ME* ]] || die "disko device not configured for $HOST (contains REPLACE_ME)"

  if [[ ! -f "${NIX_SECRETS_PATH}/users/${PRIMARY_USER}.yaml" ]]; then
    echo "warn: ${NIX_SECRETS_PATH}/users/${PRIMARY_USER}.yaml missing — full deploy may fail"
  fi

  ssh-keygen -R "$IP" 2>/dev/null || true

  ping -c 1 -W 2 "$IP" >/dev/null || die "host $IP unreachable"
  log_ok "Installer reachable"

  ssh_target 'echo ok' >/dev/null || die "SSH to root@${IP} failed"

  ssh_target '
    set -euo pipefail
    command -v nix >/dev/null || { echo "nix missing" >&2; exit 1; }
    command -v lsblk >/dev/null || { echo "lsblk missing" >&2; exit 1; }
    ping -c 1 1.1.1.1 >/dev/null || { echo "no internet" >&2; exit 1; }
  ' || die "remote environment checks failed"
  log_ok "Internet reachable"

  ssh_target "test -b '${DEVICE}'" || die "disk device ${DEVICE} not found on installer"
  log_ok "Disk verified"

  echo
  echo "Expected install disk: ${DEVICE}"
  echo
  ssh_target 'lsblk -d -o NAME,SIZE,MODEL,TYPE'
  echo
  read -rp "Type 'install' to continue: " CONFIRM
  [[ "$CONFIRM" == "install" ]] || die "aborted by user"
  log_ok "User confirmed"

if [[ -z "${DISKO_PASSWORD:-}" ]]; then
  while true; do
    read -rsp "LUKS passphrase for ${HOST}: " p1
    echo
    read -rsp "Confirm LUKS passphrase for ${HOST}: " p2
    echo

    if [[ -z "$p1" ]]; then
      echo "Password cannot be empty"
      continue
    fi

    if [[ "$p1" != "$p2" ]]; then
      echo "Passwords do not match, try again"
      continue
    fi

    DISKO_PASSWORD="$p1"
    break
  done
fi
  printf '%s' "$DISKO_PASSWORD" | ssh "${SSH_OPTS[@]}" "root@${IP}" "cat > '${LUKS_FILE}' && chmod 600 '${LUKS_FILE}'"
fi

ALREADY_INSTALLED=0
if ssh_target 'test -f /run/current-system' 2>/dev/null; then
  ALREADY_INSTALLED=1
fi

# --- Phase 3: nixos-anywhere ---
if [[ "$RUN_INSTALL" == "1" && "$ALREADY_INSTALLED" == "0" ]]; then
  log_step "Installing ${HOST}-bootstrap on ${IP}"

  HW_ARGS=()
  if nix_eval_bool "$GENERATE_HARDWARE"; then
    HW_ARGS=(
      --generate-hardware-config
      nixos-generate-config
      "$HW_PATH"
    )
  fi

  ANYWHERE_EXTRA=()
  while IFS= read -r flag; do
    [[ -n "$flag" ]] && ANYWHERE_EXTRA+=("$flag")
  done < <(nix eval --json "${SPEC}.nixosAnywhereExtra" | jq -r '.[]?')

  # shellcheck disable=SC2086
  nix run github:nix-community/nixos-anywhere -- \
    "${HW_ARGS[@]}" \
    --build-on-remote \
    --flake ".#${HOST}-bootstrap" \
    --target-host "root@${IP}" \
    ${ANYWHERE_EXTRA[@]+"${ANYWHERE_EXTRA[@]}"}

  if nix_eval_bool "$GENERATE_HARDWARE" && [[ -n "$(git status --porcelain -- "$HW_PATH")" ]]; then
    git add -- "$HW_PATH"
    git commit -m "chore(${HOST}): add generated hardware-configuration.nix"
  fi

  log_ok "Installation complete"
  ALREADY_INSTALLED=1
elif [[ "$RUN_INSTALL" == "1" && "$ALREADY_INSTALLED" == "1" ]]; then
  log_ok "Installation skipped (system already installed)"
fi

# --- Phase 4: wait for SSH ---
if [[ "$RUN_WAIT" == "1" ]]; then
  log_step "Waiting for first boot"

  ssh-keygen -R "$IP" 2>/dev/null || true

  deadline=$((SECONDS + SSH_TIMEOUT))
  until ssh "${SSH_OPTS[@]}" "root@${IP}" 'echo ok' 2>/dev/null; do
    [[ "$SECONDS" -lt "$deadline" ]] || die "SSH timeout after ${SSH_TIMEOUT}s"
    sleep 5
  done
  log_ok "First boot detected"
fi

# --- Phase 5-7: SOPS enrollment ---
if [[ "$RUN_SOPS" == "1" ]]; then
  log_step "Bootstrapping SOPS"

  [[ -d "$NIX_SECRETS_PATH" ]] || die "nix-secrets not found at $NIX_SECRETS_PATH"
  git -C "$NIX_SECRETS_PATH" rev-parse >/dev/null 2>&1 || die "nix-secrets is not a git repo: $NIX_SECRETS_PATH"

  PUB="$(ssh_target 'cat /etc/ssh/ssh_host_ed25519_key.pub')"
  RECIPIENT="$(echo "$PUB" | ssh-to-age)"
  [[ "$RECIPIENT" == age1* ]] || die "ssh-to-age failed: ${RECIPIENT}"

  existing_age=""
  if grep -q "&${ANCHOR}" "$SOPS_YAML"; then
    existing_age="$(grep "&${ANCHOR}" "$SOPS_YAML" | sed -E 's/.*&'"${ANCHOR}"'[[:space:]]+(age1[^[:space:]]+).*/\1/' | head -1)"
    if [[ -n "$existing_age" && "$existing_age" != "$RECIPIENT" ]]; then
      die "SOPS anchor &${ANCHOR} exists with different recipient (${existing_age}). Remove it manually and re-run."
    fi
    if [[ "$existing_age" == "$RECIPIENT" ]]; then
      log_ok "Age recipient already enrolled"
    fi
  fi

  if ! grep -q "&${ANCHOR}" "$SOPS_YAML"; then
    python3 - <<PYEOF
lines = open("$SOPS_YAML").readlines()
out, inserted = [], False
for line in lines:
    out.append(line)
    if not inserted and line.rstrip() == "keys:":
        out.append(f"  - &${ANCHOR} ${RECIPIENT}\n")
        inserted = True
if not inserted:
    raise SystemExit("could not find keys: in .sops.yaml")
open("$SOPS_YAML", "w").writelines(out)
PYEOF

    if ! grep -q "hosts/${HOST}.yaml" "$SOPS_YAML"; then
      cat >>"$SOPS_YAML" <<YAML
  - path_regex: hosts/${HOST}\\.yaml\$
    key_groups:
      - age:
          - *${ANCHOR}
YAML
    fi
    log_ok "Age recipient generated"
  fi

  HOST_YAML="${NIX_SECRETS_PATH}/hosts/${HOST}.yaml"
  if [[ ! -f "$HOST_YAML" ]]; then
    TEMPLATE="${NIX_SECRETS_PATH}/templates/host.yaml"
    [[ -f "$TEMPLATE" ]] || die "template not found: $TEMPLATE"
    mkdir -p "$(dirname "$HOST_YAML")"
    cp "$TEMPLATE" "$HOST_YAML"
  fi

  if ! grep -q '^[[:space:]]*sops:' "$HOST_YAML"; then
    (cd "$NIX_SECRETS_PATH" && sops --encrypt --in-place "hosts/${HOST}.yaml")
  fi

  NEED_UPDATEKEYS=1
  if [[ -n "$existing_age" && "$existing_age" == "$RECIPIENT" ]]; then
    NEED_UPDATEKEYS=0
  fi

  if [[ "$NEED_UPDATEKEYS" == "1" ]]; then
    (cd "$NIX_SECRETS_PATH" && sops updatekeys -y "hosts/${HOST}.yaml" "shared.yaml")
    log_ok "Secrets updated"
  fi

  (
    cd "$NIX_SECRETS_PATH"
    if [[ -n "$(git status --porcelain)" ]]; then
      git add -A
      git commit -m "feat(${HOST}): add age recipient"
      if nix_eval_bool "$PUSH_SECRETS"; then
        git push || die "git push to nix-secrets failed"
      fi
      log_ok "Secrets pushed"
    fi
  )

  nix flake update nix-secrets
  if [[ -n "$(git status --porcelain -- flake.lock)" ]]; then
    git add flake.lock
    git commit -m "chore: update nix-secrets flake lock for ${HOST}"
  fi
fi

# --- Phase 8: full deploy ---
if [[ "$RUN_DEPLOY" == "1" ]]; then
  log_step "Deploying full configuration"

  if [[ ! -f "${NIX_SECRETS_PATH}/users/${PRIMARY_USER}.yaml" ]]; then
    echo "warn: users/${PRIMARY_USER}.yaml missing in nix-secrets — deploy will likely fail"
  fi

  nix run nixpkgs#nixos-rebuild -- \
    --flake ".#${HOST}" \
    --target-host "root@${IP}" \
    --build-host "root@${IP}" \
    switch

  log_ok "Deployment complete"
fi

# --- Phase 9: validation ---
if [[ "$RUN_VALIDATE" == "1" ]]; then
  log_step "Validation"

  ssh_target '
    set -euo pipefail
    echo "Failed units:"
    systemctl --failed --no-legend || true
    systemctl is-active sops-nix
    test -f /var/lib/sops-nix/key.txt
    echo "nixos-version: $(nixos-version)"
  '

  log_ok "Validation complete"
fi

echo
echo "Done."
