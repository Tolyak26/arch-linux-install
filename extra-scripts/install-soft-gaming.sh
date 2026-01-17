#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo ""
echo "- Installing packages for gaming ... "
echo ""

## Steam
sudo pacman -S --noconfirm --disable-download-timeout --needed steam lib32-gnutls

sudo sed -i 's|^Exec=/usr/bin/steam %U$|Exec=/usr/bin/steam -system-composer %U|' /usr/share/applications/steam.desktop
##

## Gamemode by Feral Interactive
sudo pacman -S --noconfirm --disable-download-timeout --needed gamemode lib32-gamemode
##

## Mangohud & Goverlay
sudo pacman -S --noconfirm --disable-download-timeout --needed mangohud lib32-mangohud goverlay
##

## ProtonUp-Qt
yay -S --noconfirm --needed --removemake protonup-qt
##

## Bottles
yay -S --noconfirm --needed --removemake bottles
##

## xpadneo
sudo pacman -S lld
yay -S --noconfirm --needed --removemake xpadneo-dkms
##
