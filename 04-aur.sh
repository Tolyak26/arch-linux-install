#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

# Import settings from setup.conf
source $HOME/arch-linux-install/setup.conf

echo "- Installing AUR Helper ... "
echo ""
cd $HOME
git clone https://aur.archlinux.org/yay.git
cd $HOME/yay
sudo pacman -S --noconfirm --needed go
makepkg -si --noconfirm --needed
echo ""

echo "- Installing AUR packages ... "
echo ""
yay -S --noconfirm --needed - < $HOME/arch-linux-install/pkg-lists/pkg-aur.txt