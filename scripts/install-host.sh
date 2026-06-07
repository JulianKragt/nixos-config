#!/usr/bin/env bash
set -euo pipefail

HOST="$1"
IP="$2"


echo "Checking connectivity to $HOST ($IP)..."

echo
echo -e "\e[33m===============================================\e[0m"
echo -e "\e[33mOn the new divice run \`sudo password\` and give a temporary password\e[0m"
echo -e "\e[33mThis is needed for connecting via SSH\e[0m"
echo -e "\e[33m===============================================\e[0m"
echo

if ! ping -c 1 -W 2 "$IP" >/dev/null 2>&1; then
  echo "ERROR: Host $IP is unreachable."
  exit 1
fi

if ! ssh \
  -o ConnectTimeout=5 \
  -o StrictHostKeyChecking=no \
  root@"$IP" 'echo "SSH OK"' >/dev/null 2>&1; then
  echo "ERROR: SSH connection to root@$IP failed."
  exit 1
fi

echo "Connection successful."


ssh root@"$IP" '
set -euo pipefail

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

echo "NIXOS VERSION:"
test -r /etc/os-release || fail "missing /etc/os-release"

echo "CHECKING REQUIRED TOOLS:"

command -v nix >/dev/null 2>&1 && echo "nix OK" || fail "nix missing"
command -v lsblk >/dev/null 2>&1 && echo "lsblk OK" || fail "lsblk missing"
command -v git  >/dev/null 2>&1 && echo "git OK"  || fail "git missing"

echo "NETWORK:"
ping -c 1 1.1.1.1 >/dev/null 2>&1 && echo "internet OK" || fail "no internet"

echo "ALL CHECKS PASSED"


echo
echo "Available disks:"
lsblk -d -o NAME,SIZE,MODEL,TYPE

echo
echo -e "\e[33m===============================================\e[0m"
echo -e "\e[33mUpdate your disko config now if needed.\e[0m"
echo -e "\e[33mAvailable disks were shown above.\e[0m"
echo
echo -e "\e[33mType \`install\` to continue.\e[0m"
echo -e "\e[33m===============================================\e[0m"
echo

read -rp "Type \`install\` to continue: " CONFIRM

if [[ "$CONFIRM" != "install" ]]; then
  echo "Aborted."
  exit 1
fi

'

