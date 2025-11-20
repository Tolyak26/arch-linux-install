#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo ""
echo "- Installing packages for system utilities ... "
echo ""

## Mint Stick Utility
yay -S --noconfirm --needed --removemake mintstick-git
##

## Timeshift
sudo pacman -S --noconfirm --disable-download-timeout --needed timeshift
##

## woeusb-ng
yay -S --noconfirm --needed --removemake woeusb-ng
##

## Ventoy (Binary)
yay -S --noconfirm --needed --removemake ventoy-bin
##

## CPU-X
sudo pacman -S --noconfirm --disable-download-timeout --needed cpu-x
##

## Gnome Disk Utility
sudo pacman -S --noconfirm --disable-download-timeout --needed gnome-disk-utility
##
