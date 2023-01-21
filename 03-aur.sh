#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

# Import settings from setup.conf
source $HOME/arch-linux-install/setup.conf

echo "- Installing AUR Helper ... "
echo ""
sleep 3

cd $HOME
git clone https://aur.archlinux.org/yay.git
cd $HOME/yay
sudo pacman -S --noconfirm --needed go
makepkg -si --noconfirm --needed
rm -rf $HOME/yay
echo ""

echo "- Installing AUR Desktop Environment packages ... "
echo ""
sleep 3

yay -S --noconfirm --needed - < $HOME/arch-linux-install/pkg-lists/pkg-aur-desktopenvironment-$desktopenvironment.txt
echo ""

echo "- Installing AUR User Software packages ... "
echo ""
sleep 3

yay -S --noconfirm --needed - < $HOME/arch-linux-install/pkg-lists/pkg-aur-user-soft.txt