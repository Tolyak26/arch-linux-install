#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

script="$( readlink -f "${BASH_SOURCE[0]}" )"
scriptdir="$( dirname "$script" )"

cd "$scriptdir" || exit 1

# Import settings from setup.conf
source $scriptdir/setup.conf

echo ""
echo "- Installing AUR Helper ... "
echo ""

cd $HOME
git clone https://aur.archlinux.org/yay.git
cd $HOME/yay
sudo pacman -S --noconfirm --needed go
makepkg -si --noconfirm --needed
rm -rf $HOME/yay
cd $scriptdir

sleep 3
echo ""
echo "- Installing AUR Desktop Environment packages ... "
echo ""

yay -S --noconfirm --noeditmenu --needed --removemake - < $scriptdir/pkg-lists/pkg-aur-desktopenvironment-$desktopenvironment.txt

sleep 3
echo ""
echo "- Installing AUR User Software packages ... "
echo ""

yay -S --noconfirm --noeditmenu --needed --removemake - < $scriptdir/pkg-lists/pkg-aur-user-soft.txt

echo ""