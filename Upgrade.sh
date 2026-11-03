#!/usr/bin/env bash
#
# Upgrade.sh - one-command system maintenance for Debian-based systems
# (Kali, Debian, Ubuntu, ...).
#
# What it does, in order:
#   1. apt-get update       - refresh the package index
#   2. apt-get dist-upgrade - upgrade all installed packages, adding/removing
#                             packages when dependencies require it
#   3. apt-get autoremove   - remove packages that are no longer needed
#   4. apt-get autoclean    - delete obsolete package files from the local cache
#
# Usage:
#   chmod +x Upgrade.sh
#   ./Upgrade.sh
#
# Notes:
#   - Needs sudo (or run it as root).
#   - Normal apt output is hidden to keep the screen tidy; errors are still shown.
#   - Stops at the first step that fails and tells you which one it was.
#   - Runs non-interactively (-y): dist-upgrade may remove packages without asking,
#     and if a package ships a new version of a config file you've edited, your
#     existing file is kept.
#
# Author: GLOBEX | https://tryhackme.com/p/GLOBEX

set -Eeuo pipefail

# On any failure, report which step it happened in
CURRENT_STEP="starting up"
trap 'echo "Error: failed during \"$CURRENT_STEP\" (script line $LINENO)." >&2' ERR

# Use sudo unless we're already root
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo "Error: this script needs root privileges and 'sudo' was not found." >&2
        exit 1
    fi
    SUDO="sudo"
fi

# Run one apt-get step: print a label, hide normal output, keep errors visible.
# DEBIAN_FRONTEND + the dpkg options stop apt from waiting on a hidden prompt.
apt_step() {
    local message="$1"
    shift
    CURRENT_STEP="$message"
    echo "$message"
    $SUDO env DEBIAN_FRONTEND=noninteractive apt-get "$@" -y \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" > /dev/null
    echo ""
}

echo ""
echo "Starting System Update and Upgrade..."
echo ""

apt_step "Updating the Package Index..." update
apt_step "Performing a Full Upgrade, Handling Dependencies..." dist-upgrade
apt_step "Removing Unnecessary Dependencies..." autoremove
apt_step "Cleaning up Obsolete Package Files..." autoclean

echo "System Update and Upgrade Complete!"

# Debian/Ubuntu drop this file when an update needs a reboot (Kali may not)
if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required to finish applying updates."
fi
echo ""
