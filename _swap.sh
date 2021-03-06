#!/bin/bash -e
# This script adds a 1GB swapfile to the system

function do_err() {
    code=$?
    echo "Command failed with code $code: $BASH_COMMAND"
    exit $code

}
trap do_err ERR


function set_swappiness() {
  if ! grep -q '^vm.swappiness' /etc/sysctl.conf; then
    echo -n 'Setting '
    sysctl -w vm.swappiness=10
    echo vm.swappiness = 10 >> /etc/sysctl.conf
  fi
}

function get_new_swapfile() {
  for i in $(seq 0 99); do
    if [ ! -e /swapfile."$i" ]; then
      echo /swapfile."$i"
      return
    fi
  done
  # ERROR: >100 swapfiles already exist
  echo "ERR: too many swapfiles"
  exit 1
}

[ "$(id -u)" -eq 0 ] || { echo "You must be root to run this script"; exit 1; }

# @dev default 1GB
declare -i num_gb
num_gb="${1-1}"
[ "$num_gb" -lt 1 ] && { echo "Please specify an integer >= 1"; exit 1; }
echo "Creating a ${num_gb}GB swapfile..."

set_swappiness

SWAPFILE=$(get_new_swapfile)

umask 077
# shellcheck disable=SC2004
dd if=/dev/zero of="$SWAPFILE" bs=1k count=$(($num_gb * 1024 * 1024)) conv=excl
mkswap "$SWAPFILE"
swapon "$SWAPFILE"
echo "$SWAPFILE swap swap auto 0 0" >> /etc/fstab

echo "1GiB swapfile successfully added"
