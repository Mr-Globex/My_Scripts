#!/bin/bash

# This is an automated script made by me, GLOBEX, for simpler and efficient system maintenance.
# With this script, I can easily update and upgrade my system without having to manually type the commands everytime I want to.
# The extra echo commands in there make the output look more tidy and distinguishable at a glance.

echo ""
echo "Starting System Update and Upgrade..."
echo ""

# Update the Package Index
echo "Updating the Package Index..."
sudo apt-get update -y 1> /dev/null
echo ""

# Upgrade Installed Packages
echo "Upgrading Installed Packages..."
sudo apt-get upgrade -y 1> /dev/null
echo ""

# Fully Uprade the System
echo "Performing a Full Upgrade, Handling Dependencies..."
sudo apt-get dist-upgrade -y 1> /dev/null
echo ""

# Remove Unnecessary Packages
echo "Removing Unnecessary Dependencies..."
sudo apt-get autoremove -y 1> /dev/null
echo ""

# Remove Only Obsolete Dependencies
echo "Cleaning up Obsolete Package Files..."
sudo apt-get autoclean -y 1> /dev/null
echo ""

# Done!
echo "System Update and Upgrade Complete!"
echo ""
